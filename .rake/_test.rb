require 'foodcritic'
require 'rspec/core/rake_task'
require "rubocop/rake_task"

desc 'Default task runs foodcritic, RuboCop and Chefspec'
task :test => ["test:foodcritic", "test:rubocop", "test:chefspec"]

namespace :test do
  FoodCritic::Rake::LintTask.new

  desc "Run RuboCop linter"
  RuboCop::RakeTask.new

  RSpec::Core::RakeTask.new(:chefspec)
  desc "Run RSpec unit tests"
end

# Run these separately than test task, due to resource intensiveness
require 'kitchen/rake_tasks'
Kitchen::RakeTasks.new
