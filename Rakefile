# -*- coding: UTF-8 -*_
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec)

Rubocop::RakeTask.new(:rubocop) do |task|
  task.patterns = [
    'lib/**/*.rb', 'spec/*_spec.rb', 'Rakefile', 'rmuh.gemspec', 'Gemfile'
  ]
  # task.formatters = ['files']
  task.fail_on_error = true
end

task default: [:rubocop, :spec]
