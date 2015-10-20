require "rspec/core/rake_task"
require "rubocop/rake_task"

desc "Default task runs foodcritic, RuboCop and Chefspec"
task test: ["test:foodcritic", "test:rubocop", "test:chefspec"]

namespace :test do
  desc "Runs foodcritic linter"
  task :foodcritic do
    sh "foodcritic --epic-fail any ."
  end

  desc "Run RuboCop linter"
  RuboCop::RakeTask.new

  desc "Run ChefSpec unit tests"
  RSpec::Core::RakeTask.new(:chefspec)
end

# Run these separately than test task, due to resource intensiveness
require "kitchen/rake_tasks"
desc "Run test-kitchen integration tests"
Kitchen::RakeTasks.new
