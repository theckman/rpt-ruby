#!/usr/bin/env ruby
# -*- coding: UTF-8 -*-
#
# This shows you how to use the ServerStats::Advanced class. The only
# difference between ::Base and ::Advanced is that Advanced gives you stats
# accessors using dot notation. You can see more about the ::Base class within
# the basic_serverstats.rb file
#
# It also has all the same caching characteristics as the ::Base class and you
# can learn more about those in the serverstats_cache.rb file.
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'rmuh/serverstats/advanced'
require 'ap'

# specify the UnitedOperations server
SRV = { host: 'srv1.unitedoperations.net', port: 2_302 }

# build a new instance of ::Advanced
s = RMuh::ServerStats::Advanced.new(host: SRV[:host], port: SRV[:port])

# print the full stats out
ap s.stats

# print only the players Array
ap s.players
