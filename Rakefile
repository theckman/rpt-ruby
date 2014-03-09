# -*- coding: UTF-8 -*_
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec)

Rubocop::RakeTask.new(:rubocop) do |t|
  t.patterns = %w{ Rakefile Gemfile rmuh.gemspec lib/**/*.rb spec/*_spec.rb }
  t.fail_on_error = true
end

task default: [:rubocop, :spec]
