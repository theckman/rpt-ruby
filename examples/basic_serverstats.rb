#!/usr/bin/env ruby
# -*- coding: UTF-8 -*-
#
# This example shows you how to use the ServerStats class to pull real-time
# information about the server from the GameSpy protocol
#
# This includes map name, mission name, player list, game version, required
# mods, and a bunch of other information.
#
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'rmuh/serverstats/base'
require 'ap'

# specify the UnitedOperations server
SRV = { host: 'srv1.unitedoperations.net', port: 2_302 }

# get an instance of ServerStats and print the stats
# by default this is a blocking operation. See serverstats_cache.rb for
# alternative options
s = RMuh::ServerStats::Base.new(host: SRV[:host], port: SRV[:port])
ap s.stats
