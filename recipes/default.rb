#
# Cookbook Name:: chef-opentsdb_handler
# Recipe:: default
#
# This installs the opentsdb handler
#

include_recipe "chef_handler"

cookbook_file node["opentsdb_handler"]["handler_path"] do
  source "opentsdb_handler.rb"
  mode "0600"
  action :nothing
end.run_action(:create)

chef_handler "Chef::Handler::OpenTSDB" do
  source node["opentsdb_handler"]["handler_path"]
  arguments [
    node["opentsdb_handler"]
  ]
  action :nothing
end.run_action(:enable)
