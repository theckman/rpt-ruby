# -*- coding: UTF-8 -*_
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec)

RuboCop::RakeTask.new(:rubocop) do |t|
  # t.patterns = %w( Rakefile Gemfile rmuh.gemspec lib/**/*.rb spec/*_spec.rb )
  t.patterns = %w( rmuh.gemspec lib/**/*.rb spec/*_spec.rb )
  t.fail_on_error = true
end

RSpec::Core::RakeTask.new(:unit) do |t|
  t.pattern = ['spec/spec_helper.rb', 'spec/unit/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:example) do |t|
  t.pattern = ['spec/spec_helper.rb', 'spec/functional/**/*_spec.rb']
end

task :unit do
  Rake::Task['unit'].invoke
end

task :example do
  Rake::Task['unit'].invoke
end

task default: [:rubocop, :spec]
