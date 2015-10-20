require "net/http"
require "json"
require "serverspec"
require "uri"

set :backend, :exec

# rubocop:disable Style/GlobalVars
$node = ::JSON.parse(File.read("/opt/serverspec/node.json"))


