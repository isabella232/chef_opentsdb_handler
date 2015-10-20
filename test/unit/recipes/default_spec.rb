require_relative File.expand_path("../../spec_helper.rb", __FILE__)

describe "opentsdb_handler::default" do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set["opentsdb_handler"]["handler_path"] = "handler_file"
    end.converge(described_recipe)
  end

  it "creates the handler template" do
    expect(chef_run).to create_template("handler_file").at_compile_time.with(
      source: "opentsdb_handler.rb.erb",
      mode: "0600"
    )
  end

  it "enables the opentsdb handler" do
    expect(chef_run).to enable_chef_handler("Chef::Handler::OpenTSDB").at_compile_time.with(
      source: "handler_file",
      arguments: [
        { "default_hostname" => "opentsdb",
          "default_port" => 4242,
          "default_tags" => { "hostname" => "chefspec" },
          "default_timeout" => 10,
          "add_run_status_tag" => true,
          "handlers" => {},
          "handler_path" => "handler_file" }]
    )
  end
end
