require_relative "./spec_helper"

# rubocop:disable Style/GlobalVars
describe file($node["opentsdb_handler"]["handler_path"]) do
  it { should be_file }
  it { should be_mode 600 }
end
