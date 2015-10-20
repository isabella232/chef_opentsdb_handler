require_relative File.expand_path("../../spec_helper.rb", __FILE__)

describe Chef::Handler::OpenTSDB do
  # create a dummy class to mock chef handler methods
  let(:dummy_class) do
    Class.new do
      def success?
        0
      end

      def elapsed_time
        100
      end
    end
  end

  before do
    allow(Time).to receive(:now).and_return(1)
    allow_any_instance_of(described_class).to receive(:run_status).and_return(dummy_class.new)
  end

  describe "#format_body" do
    it "returns a json string" do
      metric = {
        "name" => "test",
        "timestamp" => 1,
        "value" => 1,
        "tags" => { "tag1" => "value1" }
      }
      expected_metric = {
        "metric" => "test",
        "timestamp" => 1,
        "value" => 1,
        "tags" => { "tag1" => "value1" }
      }

      expect(described_class.new.send(:format_body, metric)).to eq(expected_metric.to_json)
    end
  end

  describe "#get_tags" do
    it "returns with default tags" do
      metric_without_tags = {
        "name" => "test",
        "timestamp" => 1,
        "value" => 1
      }

      tag_key = described_class.new.send(:get_tags, metric_without_tags).keys[0]

      expect(tag_key).to eq("host")
    end

    context "when run_status is true" do
      it "it returns run_satus tag" do
        metric_without_tags = {
          "metric" => "test",
          "timestamp" => 1,
          "value" => 1,
          "run_status_tag" => true
        }

        tag_value = described_class.new.send(:get_tags, metric_without_tags)["run_status"]

        expect(tag_value).to eq(0)
      end
    end
  end

  describe "#add_run_status_metrics" do
    context "with no run_status set to true" do
      it "should have run_status metrics" do
        config = {
          "run_status" => {
            "elapsed_time" => false
          },
          "metrics" => {}
        }
        handler_object = described_class.new(config)

        expect(handler_object.send(:add_run_status_metrics)).to be_empty
      end
    end
    context "with elapsed_time set to true" do
      it "should have run_status metrics" do
        config = {
          "run_status" => {
            "elapsed_time" => true
          },
          "metrics" => {}
        }
        handler_object = described_class.new(config)

        expect(handler_object.send(:add_run_status_metrics)["elapsed_time"]).not_to be_empty
      end
    end
  end
end
