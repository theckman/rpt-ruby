# -*- coding: UTF-8 -*-

describe RMuh::RPT::Log::Util::UnitedOperationsLog do
  before(:all) do
    @uo_util = Class.new
    @uo_util.extend(RMuh::RPT::Log::Util::UnitedOperationsLog)
  end

  context '::ONE_DAY' do
    it 'should be an instance of Fixnum' do
      expect(
        RMuh::RPT::Log::Util::UnitedOperationsLog::ONE_DAY
      ).to be_an_instance_of Fixnum
    end

    it 'should be 24 hours in seconds' do
      expect(RMuh::RPT::Log::Util::UnitedOperationsLog::ONE_DAY).to eql 86_400
    end
  end

  context '::TIME' do
    it 'should be an instance of String' do
      expect(
        RMuh::RPT::Log::Util::UnitedOperationsLog::TIME
      ).to be_an_instance_of String
    end
  end

  context '::GUID' do
    it 'should be an instance of Regexp' do
      expect(
        RMuh::RPT::Log::Util::UnitedOperationsLog::GUID
      ).to be_an_instance_of Regexp
    end

    it 'should match an example line' do
      l = ' 4:01:02 BattlEye Server: Verified GUID ' \
          '(04de012b0f882b9ff2e43564c8c09361) of player #0 nametag47'
      m = RMuh::RPT::Log::Util::UnitedOperationsLog::GUID.match(l)
      expect(m).to_not be_nil
      expect(m['hour']).to eql '4'
      expect(m['min']).to eql '01'
      expect(m['sec']).to eql '02'
      expect(m['player_beguid']).to eql '04de012b0f882b9ff2e43564c8c09361'
      expect(m['player']).to eql 'nametag47'
    end
  end

  context '::CHAT' do
    it 'should be an instance of Regexp' do
      expect(
        RMuh::RPT::Log::Util::UnitedOperationsLog::CHAT
      ).to be_an_instance_of Regexp
    end

    it 'should match an example line' do
      l = ' 5:48:01 BattlEye Server: (Side) Xcenocide: Admin back'
      m = RMuh::RPT::Log::Util::UnitedOperationsLog::CHAT.match(l)
      expect(m['hour']).to eql '5'
      expect(m['min']).to eql '48'
      expect(m['sec']).to eql '01'
      expect(m['channel']).to eql 'Side'
      expect(m['player']).to eql 'Xcenocide'
      expect(m['message']).to eql 'Admin back'
    end
  end
end
