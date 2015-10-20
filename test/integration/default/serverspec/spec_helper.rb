require "serverspec"
require "json"

set :backend, :exec

# rubocop:disable Style/GlobalVars
$node = ::JSON.parse(File.read("/opt/serverspec/node.json"))
