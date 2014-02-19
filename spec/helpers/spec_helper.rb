# -*- coding: UTF-8 -*-
require 'rspec'
require 'simplecov'
require 'coveralls'

def repo_root
  File.expand_path('../../..', __FILE__)
end

SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_filter '/spec/'
end
