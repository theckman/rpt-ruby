#!/usr/bin/env ruby
# -*- coding: UTF-8 -*-
#
# This script shows you how to use the UnitedOperations LOG parser
#
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'rmuh/rpt/log/fetch'
require 'rmuh/rpt/log/parsers/unitedoperationslog'
require 'ap'

# the server log file
URL = 'http://arma2.unitedoperations.net/dump/SRV1/SRV1_LOG.txt'

# instantiate a new fetcher with the log file
f = RMuh::RPT::Log::Fetch.new(URL)

# instantiate a new UnitedOperationsRPT parser
p = RMuh::RPT::Log::Parsers::UnitedOperationsLog.new

# parse the log from the server
# we are doing it inline
parsed = p.parse(f.log)

# print out the hash
puts '#### Metadata Hash'
ap parsed, indent: -2
puts '#### End of Hashes'
