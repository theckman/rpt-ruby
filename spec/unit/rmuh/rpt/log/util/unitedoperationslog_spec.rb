# -*- coding: UTF-8 -*-

describe RMuh::RPT::Log::Util::UnitedOperationsLog do
  before(:all) do
    @uo_util = Class.new
    @uo_util.extend(RMuh::RPT::Log::Util::UnitedOperationsLog)
  end

  describe '::ONE_DAY' do
    subject { RMuh::RPT::Log::Util::UnitedOperationsLog::ONE_DAY }

    it { should be_an_instance_of Fixnum }

    it { should eql 86_400 }
  end

  describe '::TIME_SHORT' do
    subject { RMuh::RPT::Log::Util::UnitedOperationsLog::TIME_SHORT }

    it { should be_an_instance_of String }
  end

  describe '::TIME' do
    subject { RMuh::RPT::Log::Util::UnitedOperationsLog::TIME }

    it { should be_an_instance_of String }
  end

  describe '::GUID' do
    subject { RMuh::RPT::Log::Util::UnitedOperationsLog::GUID }

    it { should be_an_instance_of Regexp }

    it 'should match an example line' do
      l = ' 4:01:02 BattlEye Server: Verified GUID ' \
          '(04de012b0f882b9ff2e43564c8c09361) of player #0 nametag47'
      m = subject.match(l)
      expect(m).to_not be_nil
      expect(m['hour']).to eql '4'
      expect(m['min']).to eql '01'
      expect(m['sec']).to eql '02'
      expect(m['player_beguid']).to eql '04de012b0f882b9ff2e43564c8c09361'
      expect(m['player']).to eql 'nametag47'
      expect(m['player_num']).to eql '0'
    end
  end

  describe '::CHAT' do
    subject { RMuh::RPT::Log::Util::UnitedOperationsLog::CHAT }

    it { should be_an_instance_of Regexp }

    it 'should match an example line' do
      l = ' 5:48:01 BattlEye Server: (Side) Xcenocide: Admin back'
      m = subject.match(l)
      expect(m['hour']).to eql '5'
      expect(m['min']).to eql '48'
      expect(m['sec']).to eql '01'
      expect(m['channel']).to eql 'Side'
      expect(m['player']).to eql 'Xcenocide'
      expect(m['message']).to eql 'Admin back'
    end
  end

  describe '::JOINED' do
    subject { RMuh::RPT::Log::Util::UnitedOperationsLog::JOINED }

    it { should be_an_instance_of Regexp }

    it 'should match an example line' do
      l = ' 4:01:09 BattlEye Server: Player #0 Delta38 ' \
          '(127.0.0.1:65007) connected'
      m = subject.match(l)
      expect(m['hour']).to eql '4'
      expect(m['min']).to eql '01'
      expect(m['sec']).to eql '09'
      expect(m['player']).to eql 'Delta38'
      expect(m['player_num']).to eql '0'
      expect(m['net']).to eql  '127.0.0.1:65007'
    end
  end

  describe '::LEFT' do
    subject { RMuh::RPT::Log::Util::UnitedOperationsLog::LEFT }

    it { should be_an_instance_of Regexp }

    it 'should match an example line' do
      l = ' 5:05:53 Player MPWR disconnected.'
      m = subject.match(l)
      expect(m['hour']).to eql '5'
      expect(m['min']).to eql '05'
      expect(m['sec']).to eql '53'
      expect(m['player']).to eq 'MPWR'
    end
  end
end
