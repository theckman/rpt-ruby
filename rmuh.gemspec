# -*- coding: UTF-8 -*-
require 'English'

$LOAD_PATH << File.expand_path('../lib', __FILE__)

require 'rmuh/version'

Gem::Specification.new do |g|
  g.name        = 'rmuh'
  g.version     = RMuh::VERSION
  g.date        = Time.now.strftime('%Y-%m-%d')
  g.description = 'ArmA 2 Ruby Library for RPT, Log, and GameSpy'
  g.summary     = 'ArmA 2 Ruby Library'
  g.authors     = ['Tim Heckman']
  g.email       = 't@heckman.io'
  g.homepage    = 'https://github.com/theckman/rmuh'
  g.license     = 'MIT'
  g.required_ruby_version = '>= 1.9.3'

  g.test_files  = %x( git ls-files spec/* ).split
  g.files       = %x( git ls-files).split

  g.add_development_dependency 'rake', '~>10.1', '>= 10.1.0'
  g.add_development_dependency 'rspec', '~>2.14', '>= 2.14.1'
  g.add_development_dependency 'rubocop', '~> 0.21', '>= 0.21.0'
  g.add_development_dependency 'fuubar', '~> 1.3', '>= 1.3.2'
  g.add_development_dependency 'simplecov', '~> 0.8', '>= 0.8.2'
  g.add_development_dependency 'coveralls', '~> 0.7', '>= 0.7.0'
  g.add_development_dependency 'awesome_print', '~> 1.2', '>= 1.2.0'

  g.add_runtime_dependency 'tzinfo-data'
  g.add_runtime_dependency 'tzinfo', '~> 1.1', '>= 1.1.0'
  g.add_runtime_dependency 'httparty', '~> 0.12', '>= 0.12.0'
  g.add_runtime_dependency 'gamespy_query', '~> 0.1', '>= 0.1.5'
end
