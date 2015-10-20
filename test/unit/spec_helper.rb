require "chefspec"
require "chefspec/berkshelf"

# Print coverage report
ChefSpec::Coverage.start!

# Require all our libraries
Dir[File.expand_path("../../../libraries/*.rb", __FILE__)].each do |f|
  require File.expand_path(f)
end
