#!/usr/bin/env ruby
$: << 'lib'
require 'ap'
require 'rpt/log/fetch'

a = RPT::Log::Fetch.new('http://srv1.unitedoperations.net')

ap a.config.to_h.keys
