require_relative "./spec_helper"

# rubocop:disable Style/GlobalVars
describe file($node["opentsdb_handler"]["handler_path"]) do
  it { should be_file }
  it { should be_mode 600 }
end

# See .kitchen.yml for given metrics
# These shold be their own matcher rather than a command at some point

# rubocop:disable LineLength
# test.withouttags should have default tags
describe command("curl -s 'http://localhost:4242/api/query?start=2m-ago&m=sum:test.withouttags%7Bhost=default-ubuntu-1404%7D' | jq -c '.[0].dps'") do
  its(:stdout) { should match(/\{"\d{10}":1\}/) }
end

# test.withtags should not have default tags
describe command("curl -s 'http://localhost:4242/api/query?start=2m-ago&m=sum:test.withtags%7Bhost=default-ubuntu-1404%7D' | jq -c '.[0].dps'") do
  its(:stdout) { should eq("null\n") }
end

# test.withtags should have given tags
describe command("curl -s 'http://localhost:4242/api/query?start=2m-ago&m=sum:test.withtags%7Btest_tag=test_value%7D' | jq -c '.[0].dps'") do
  its(:stdout) { should match(/\{"\d{10}":1\}/) }
end

# test.withrunstatus should have run_status=0 tag
describe command("curl -s 'http://localhost:4242/api/query?start=2m-ago&m=sum:test.withrunstatus%7Brun_status=0%7D' | jq -c '.[0].dps'") do
  its(:stdout) { should match(/\{"\d{10}":1\}/) }
end

# test.withtags should not have run_status=0 tag
describe command("curl -s 'http://localhost:4242/api/query?start=2m-ago&m=sum:test.withtags%7Brun_status=0%7D' | jq -c '.[0].dps'") do
  its(:stdout) { should match("null\n") }
end

# chef.elapsed_time should exist
describe command("curl -s 'http://localhost:4242/api/query?start=2m-ago&m=sum:chef.elapsed_time%7Bhost=default-ubuntu-1404%7D' | jq -c '.[0].dps'") do
  its(:stdout) { should match(/\{"\d{10}":\d{1}\.\d*\}/) }
end
# rubocop:enable LineLength
