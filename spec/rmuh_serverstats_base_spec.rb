# -*- coding: UTF-8 -*-

require 'rspec'
require 'gamespy_query'
require 'helpers/spec_helper'
require File.join(repo_root, 'lib/rmuh/serverstats/base')
require 'rmuh_serverstats_base'

describe RMuh::ServerStats::Base do
  it_should_behave_like 'RMuh::ServerStats::Base'
end
