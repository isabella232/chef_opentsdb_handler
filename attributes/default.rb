# Used in handler template
default["opentsdb_handler"]["handlers"] = {}

# Used in recipe
default["opentsdb_handler"]["handler_path"] = File.join(node["chef_handler"]["handler_path"], "opentsdb_handler.rb")
