# Used in handler template
default["opentsdb_handler"]["handlers"] = {}
default["opentsdb_handler"]["run_status_tag"] = false
default["opentsdb_handler"]["run_status"]["elapsed_time"] = false
default["opentsdb_handler"]["run_status"]["start_time"] = false
default["opentsdb_handler"]["run_status"]["end_time"] = false

# Used in recipe
default["opentsdb_handler"]["handler_path"] = File.join(node["chef_handler"]["handler_path"], "opentsdb_handler.rb")
