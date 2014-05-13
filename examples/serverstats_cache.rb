#!/usr/bin/env ruby
# -*- coding: UTF-8 -*-
#
# By default the ServerStats::Base class caches the information from the
# server in memory. By default the class is a blocking operation on the first
# call to '.stats'. That's because if the cache is not populated it will
# poll the server.
#
# You can avoid this being blocking by setting 'auto_cache: false'. This means,
# however, that you will need to call the '.update_cache' method when you can
# afford a blocking operation
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'rmuh'
require 'ap'

# specify the UnitedOperations server
SRV = { host: 'srv1.unitedoperations.net', port: 2_302 }

s = RMuh::ServerStats::Base.new(
  host: SRV[:host], port: SRV[:port], auto_cache: false
)
ap s.stats, indent: -2 # this should be nil

# update the cache within the object from the server, then print the stats
s.update_cache
ap s.stats, indent: -2

# You can also turn off the cache completely, which means '.stats' will be a
# blocking call each time. You do this by passing 'cache: false'
s = RMuh::ServerStats::Base.new(
  host: SRV[:host], port: SRV[:port], cache: false
)

ap s.stats, indent: -2
