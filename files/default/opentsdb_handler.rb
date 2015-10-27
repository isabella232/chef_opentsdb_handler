require "chef"
require "chef/handler"
require "net/http"
require "socket"
require "timeout"

class Chef::Handler::OpenTSDB < Chef::Handler
  def initialize(config = {})
    @config = config

    @metrics = config["metrics"]
    @hostname = config["hostname"] || "opentsdb"
    @path = "/api/put"
    @port = config["port"] || 4242
    @time = Time.now.to_i # Make time the same for all metrics
    @timeout = @config["timeout"] || 10
  end

  def report
    metrics = add_run_status_metrics
    metrics.each do |_name, metric|
      begin
        Timeout.timeout(@timeout) do
          send_metric(metric)
        end
      rescue StandardError => e
        Chef::Log.warn("OpenTSDB metric failed to send metric #{metric['name']}:\n #{e}")
      end
    end
  end

  private

  def add_run_status_metrics
    # attribute is immutable  and not hash:/
    metrics = @metrics.to_hash
    @config["run_status"].each do |key, value|
      next unless value
      metric_hash = {
        "name" => "chef.#{key}",
        "value" => run_status.send(key)
      }
      if metrics[key]
        metrics[key] = metrics[key].merge(metric_hash)
      else
        metrics[key] = metric_hash
      end
    end
    metrics
  end

  def send_metric(metric)
    # rubocop:disable UselessAssignment
    req = Net::HTTP::Post.new(@path, initheader = { "Content-Type" => "application/json" })
    # rubocop:enable UselessAssignment
    req.body = format_body(metric)
    Chef::Log.info("Sending metric:\n #{req.body}")
    response = Net::HTTP.new(@hostname, @port).start { |http| http.request(req) }
    response.value
  end

  def format_body(metric)
    body = {
      "metric" => metric["name"],
      "timestamp" => @time,
      "value" => metric["value"],
      "tags" => get_tags(metric)
    }
    body.to_json
  end

  def get_tags(metric)
    # use 'host' for key due to opentsdb convention
    tags = metric["tags"] || { "host" => Socket.gethostname }
    if metric["run_status_tag"]
      tags.merge("run_status" => run_status.success? ? 0 : 1)
    else
      tags
    end
  end
end
