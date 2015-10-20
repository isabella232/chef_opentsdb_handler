require_relative File.expand_path("../../spec_helper.rb", __FILE__)

describe Chef::Handler::OpenTSDB do
  # create a dummy class to mock chef handler methods
  let(:dummy_class) do
    Class.new do
      def success?
        0
      end
    end
  end

  before do
    allow(Time).to receive(:now).and_return(1)
    described_class.any_instance.stub(:run_status).and_return(dummy_class.new)
  end

  describe "#format_body" do
    it "returns a json string" do
      handler = {
        "metric" => "test",
        "timestamp" => 1,
        "value" => 1,
        "tags" => { "tag1" => "value1" }
      }

      expect(described_class.new.send(:format_body, handler)).to eq(handler.to_json)
    end
  end

  describe "#get_tags" do
    it "returns with default tags" do
      handler_without_tags = {
        "metric" => "test",
        "timestamp" => 1,
        "value" => 1
      }

      tag_key = described_class.new.send(:get_tags, handler_without_tags).keys[0]

      expect(tag_key).to eq("host")
    end

    context "when run_status is true" do
      it "it returns run_satus tag" do
        handler_without_tags = {
          "metric" => "test",
          "timestamp" => 1,
          "value" => 1,
          "run_status_tag" => true
        }

        tag_value = described_class.new.send(:get_tags, handler_without_tags)["run_status"]

        expect(tag_value).to eq(0)
      end
    end
  end
end
