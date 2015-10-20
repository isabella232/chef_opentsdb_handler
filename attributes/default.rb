# Used in handler template
default["opentsdb_handler"]["default_hostname"] = "opentsdb"
default["opentsdb_handler"]["default_port"] = 4242
default["opentsdb_handler"]["default_tags"] = { "hostname" => node["hostname"] }
default["opentsdb_handler"]["default_timeout"] = 10
default["opentsdb_handler"]["add_run_status_tag"] = true
default["opentsdb_handler"]["handlers"] = {}

# Used in recipe
default["opentsdb_handler"]["handler_path"] = File.join(node["chef_handler"]["handler_path"], "opentsdb_handler.rb")
