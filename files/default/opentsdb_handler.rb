require "chef"
require "chef/handler"
require "net/http"
require "socket"
require "timeout"

class Chef::Handler::OpenTSDB < Chef::Handler
  def initialize(config = {})
    @config = config

    @handlers = config["handlers"]
    @hostname = config["hostname"] || "opentsdb"
    @path = "/api/put"
    @port = config["port"] || 4242
    @time = Time.now.to_i # Make time the same for all metrics
    @timeout = @config["timeout"] || 10
  end

  def report
    @handlers.each do |_name, handler|
      begin
        Timeout.timeout(@timeout) do
          send_metric(handler)
        end
      rescue StandardError => e
        Chef::Log.warn("OpenTSDB handler failed to send metric #{handler['metric']}:\n #{e}")
      end
    end
  end

  private

  def send_metric(handler)
    # rubocop:disable UselessAssignment
    req = Net::HTTP::Post.new(@path, initheader = { "Content-Type" => "application/json" })
    # rubocop:enable UselessAssignment
    req.body = format_body(handler)
    response = Net::HTTP.new(@hostname, @port).start { |http| http.request(req) }
    response.value
  end

  def format_body(handler)
    body = {
      "metric" => handler["metric"],
      "timestamp" => @time,
      "value" => handler["value"],
      "tags" => get_tags(handler)
    }
    body.to_json
  end

  def get_tags(handler)
    # use 'host' for key due to opentsdb convention
    tags = handler["tags"] || { "host" => Socket.gethostname }
    if handler["run_status_tag"]
      tags.merge("run_status" => run_status.success? ? 0 : 1)
    else
      tags
    end
  end
end
