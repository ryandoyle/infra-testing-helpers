require 'rspec/core/rake_task'
require "bundler/gem_tasks"

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/unit/**/*_spec.rb'
end

RSpec::Core::RakeTask.new(:functional) do |t|
  t.pattern = 'spec/functional/**/*_spec.rb'
end
