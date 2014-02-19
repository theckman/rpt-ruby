require 'English'

$LOAD_PATH << File.expand_path('../lib', __FILE__)

require 'rmuh/version'

Gem::Specification.new do |g|
  g.name        = 'rmuh'
  g.version     = RMuh::VERSION
  g.date        = '2014-02-18'
  g.description = 'ArmA 2 Ruby Library for RPT, Log, and GameSpy'
  g.summary     = 'ArmA 2 Ruby Library'
  g.authors     = ['Tim Heckman']
  g.email       = 't@heckman.io'
  g.homepage    = 'https://github.com/theckman/rmuh'
  g.license     = 'MIT'

  g.test_files  = %x{git ls-files spec/*}.split
  g.files       = %x{git ls-files}.split

  g.add_development_dependency 'rake', '~>10.1.0'
  g.add_development_dependency 'rspec', '~>2.14.1'

  g.add_runtime_dependency 'awesome_print', '~> 1.2.0'
  g.add_runtime_dependency 'tzinfo', '~> 1.1.0'
  g.add_runtime_dependency 'httparty', '~> 0.12.0'
  g.add_runtime_dependency 'gamespy_query', '~> 0.1.5'
end
