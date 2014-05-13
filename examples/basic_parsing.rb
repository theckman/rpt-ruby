#!/usr/bin/env ruby
# -*- coding: UTF-8 -*-
#
# This example file shows you how to do the following:
# * fetch the size of a log
# * fetch the first KB of log file
# * parse the log with the base parser
# * use awesome_print to print out the returned object
#
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'rmuh'
require 'ap'

# set a constant for the URL
URL = 'http://arma2.unitedoperations.net/dump/SRV1/SRV1_LOG.txt'

# instantiate a new fetcher object, telling it to get the first
# 1024 bytes
f = RMuh::RPT::Log::Fetch.new(URL, byte_start: 0, byte_end: 1024)

# logfile will become a StringIO object that is the contents of the log
logfile = f.log

# print the log
puts "#### The full log\n#{logfile.readlines.join("\n")}\n#### End of log!"

# print the size of the log, f.size will return a Fixnum in bytes
puts "Log size: #{f.size} byte(s)"

# instantiate a new base parser, it takes no args
p = RMuh::RPT::Log::Parsers::Base.new

# this becomes an array of hashes, each item in the Array is a metadata
# Hash for that specific log line
parsed = p.parse(f.log)

puts '#### Metadata Hash'
ap parsed, indent: -2
puts '#### End of Hashes'
