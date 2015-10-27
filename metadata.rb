name             "opentsdb_handler"
maintainer       "Optimizely inc."
maintainer_email "michael.wood@optimizely.com"
license          "MIT"
description      "Installs/Configures opentsdb_handler"
long_description IO.read(File.join(File.dirname(__FILE__), "README.md"))
source_url       "https://github.com/optimizely/chef_opentsdb_handler"
version          "0.1.1"

recipe           "opentsdb_handler::default",              "Sets up OpenTSDB chef handler"

depends          "chef_handler",                           "~> 1.2.0"
