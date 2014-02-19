# -*- coding: UTF-8 -*-
require 'rspec'
require 'helpers/spec_helper'
require File.join(repo_root, 'lib/rmuh/rpt/log/util/unitedoperationslog')

describe RMuh::RPT::Log::Util::UnitedOperationsLog do
  before(:all) do
    @uo_util = Class.new
    @uo_util.extend(RMuh::RPT::Log::Util::UnitedOperationsLog)
  end

  context '::ONE_DAY' do
    it 'should be an instance of Fixnum' do
      RMuh::RPT::Log::Util::UnitedOperationsLog::ONE_DAY
        .should be_an_instance_of Fixnum
    end

    it 'should be 24 hours in seconds' do
      RMuh::RPT::Log::Util::UnitedOperationsLog::ONE_DAY.should eql 86_400
    end
  end

  context '::TIME' do
    it 'should be an instance of String' do
      RMuh::RPT::Log::Util::UnitedOperationsLog::TIME
        .should be_an_instance_of String
    end
  end

  context '::GUID' do
    it 'should be an instance of Regexp' do
      RMuh::RPT::Log::Util::UnitedOperationsLog::GUID
        .should be_an_instance_of Regexp
    end

    it 'should match an example line' do
      l = ' 4:01:02 BattlEye Server: Verified GUID ' \
          '(04de012b0f882b9ff2e43564c8c09361) of player #0 nametag47'
      m = RMuh::RPT::Log::Util::UnitedOperationsLog::GUID.match(l)
      m.should_not be_nil
      m['hour'].should eql '4'
      m['min'].should eql '01'
      m['sec'].should eql '02'
      m['player_beguid'].should eql '04de012b0f882b9ff2e43564c8c09361'
      m['player'].should eql 'nametag47'
    end
  end

  context '::CHAT' do
    it 'should be an instance of Regexp' do
      RMuh::RPT::Log::Util::UnitedOperationsLog::CHAT
        .should be_an_instance_of Regexp
    end

    it 'should match an example line' do
      l = ' 5:48:01 BattlEye Server: (Side) Xcenocide: Admin back'
      m = RMuh::RPT::Log::Util::UnitedOperationsLog::CHAT.match(l)
      m['hour'].should eql '5'
      m['min'].should eql '48'
      m['sec'].should eql '01'
      m['channel'].should eql 'Side'
      m['player'].should eql 'Xcenocide'
      m['message'].should eql 'Admin back'
    end
  end
end
