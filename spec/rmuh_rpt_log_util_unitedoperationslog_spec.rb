# -*- coding: UTF-8 -*-
require 'rspec'
require 'helpers/spec_helper'
require File.join(repo_root, 'lib/rmuh/rpt/log/util/unitedoperationslog')

describe RMuh::RPT::Log::Util::UnitedOperationsLog do
  before(:all) do
    @uo_util = Class.new
    @uo_util.extend(RMuh::RPT::Log::Util::UnitedOperationsLog)
    @one_day = RMuh::RPT::Log::Util::UnitedOperationsLog::ONE_DAY
    @time  = RMuh::RPT::Log::Util::UnitedOperationsLog::TIME
    @guid = RMuh::RPT::Log::Util::UnitedOperationsLog::GUID
    @chat = RMuh::RPT::Log::Util::UnitedOperationsLog::CHAT
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

  context '#validate_chat' do
    it 'should not take more than one arg' do
      expect { @uo_util.validate_chat(nil, nil) }.to raise_error ArgumentError
    end

    it 'should not take less than one arg' do
      expect { @uo_util.validate_chat }.to raise_error ArgumentError
    end

    it 'should return nil if arg 1 is true' do
      @uo_util.validate_chat(chat: true).should be_nil
    end

    it 'should return nil if arg 1 is false' do
      @uo_util.validate_chat(chat: false).should be_nil
    end

    it 'should raise ArgumentError if arg 1 is a String' do
      expect { @uo_util.validate_chat(chat: '') }.to raise_error ArgumentError
    end

    it 'should raise ArgumentError if arg 1 is a Symbol' do
      expect { @uo_util.validate_chat(chat: :x) }.to raise_error ArgumentError
    end

    it 'should raise ArgumentError if arg 1 is a Fixnum' do
      expect { @uo_util.validate_chat(chat: 0) }.to raise_error ArgumentError
    end

    it 'should raise ArgumentError if arg 1 is a Float' do
      expect { @uo_util.validate_chat(chat: 0.0) }.to raise_error ArgumentError
    end

    it 'should raise ArgumentError if arg 1 is an Array' do
      expect { @uo_util.validate_chat(chat: []) }.to raise_error ArgumentError
    end

    it 'should raise ArgumentError if arg 1 is a Hash' do
      expect { @uo_util.validate_chat(chat: {}) }.to raise_error ArgumentError
    end
  end
end
