require "bundler/gem_tasks"
require "rspec/core/rake_task"

desc "Run all specs"
RSpec::Core::RakeTask.new('spec')


desc "Print specdocs"
RSpec::Core::RakeTask.new(:doc) do |t|
  t.rspec_opts = ["--dry-run"]
  t.pattern = 'spec/**/*_spec.rb'
end
