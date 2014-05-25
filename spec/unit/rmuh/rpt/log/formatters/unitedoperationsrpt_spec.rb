# -*- coding: UTF-8 -*-
require 'spec_helper'

describe RMuh::RPT::Log::Formatters::UnitedOperationsRPT do
  let(:uorpt) { RMuh::RPT::Log::Formatters::UnitedOperationsRPT }

  before do
    allow(uorpt).to receive(:time).and_return('z')
    allow(uorpt).to receive(:server_time).and_return('zt')
  end

  describe '::LEVELS' do
    subject { RMuh::RPT::Log::Formatters::UnitedOperationsRPT::LEVELS }

    it { should be_an_instance_of Array }

    it 'should only contain symbols' do
      subject.each do |l|
        expect(l).to be_an_instance_of Symbol
      end
    end
  end

  describe '.validate_and_set_level' do
    before(:each) { uorpt.instance_variable_set(:@level, nil) }

    context 'when given more than one arg' do
      it 'should raise ArgumentError' do
        expect do
          uorpt.send(:validate_and_set_level, nil, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when given less than one arg' do
      it 'should raise ArgumentError' do
        expect do
          uorpt.send(:validate_and_set_level)
        end.to raise_error ArgumentError
      end
    end

    context 'should always' do
      it 'accept the values within ::LEVELS' do
        RMuh::RPT::Log::Formatters::UnitedOperationsRPT::LEVELS.each do |l|
          expect do
            uorpt.send(:validate_and_set_level, l)
          end.not_to raise_error
          expect(uorpt.instance_variable_get(:@level)).to eql l
        end
      end
    end

    context 'when given a valid log verbosity level' do
      let(:level) { :full }

      it 'should not raise ArgumentError' do
        expect do
          uorpt.send(:validate_and_set_level, level)
        end.not_to raise_error
      end

      it 'should set the @level instance variable to your level' do
        uorpt.send(:validate_and_set_level, level)
        expect(uorpt.instance_variable_get(:@level)).to eql :full
      end
    end

    context 'when given a bullshit level, and yeah I said bullshit...' do
      it 'should raise ArgumentError :)' do
        expect do
          uorpt.send(:validate_and_set_level, :bullshit)
        end.to raise_error ArgumentError
      end
    end
  end

  describe '.time' do
    before do
      allow(uorpt).to receive(:time).and_call_original
    end

    context 'when given more than one arg' do
      it 'should raise ArgumentError' do
        expect do
          uorpt.send(:time, nil, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when given less than one arg' do
      it 'should raise ArgumentError' do
        expect do
          uorpt.send(:time, nil, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when given an event with an :iso8601 key' do
      let(:event) { { iso8601: '1970-01-01T00:00:00Z' } }

      subject { uorpt.send(:time, event) }

      it { should be_an_instance_of String }

      it { should eql '1970-01-01T00:00:00Z' }
    end
  end

  describe '.server_time' do
    before do
      allow(uorpt).to receive(:server_time).and_call_original
    end

    context 'when given more than one arg' do
      it 'should raise ArgumentError' do
        expect do
          uorpt.send(:server_time, nil, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when given less than one arg' do
      it 'should raise ArgumentError' do
        expect do
          uorpt.send(:server_time, nil, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when given an event with a :server_time key' do
      let(:event) { { server_time: 3.14 } }

      subject { uorpt.send(:server_time, event) }

      it { should be_an_instance_of String }

      it { should eql 'z "3.14 seconds:' }
    end
  end

  describe '.nearby_players' do
    context 'when given more than one arg' do
      it 'should raise ArgumentError' do
        expect do
          uorpt.send(:nearby_players, nil, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when given less than one arg' do
      it 'should raise ArgumentError' do
        expect do
          uorpt.send(:nearby_players)
        end.to raise_error ArgumentError
      end
    end

    context 'when provided an empty list of nearby players' do
      let(:event) { { nearby_players: [] } }

      subject { uorpt.send(:nearby_players, event) }

      it { should be_an_instance_of String }

      it { should eql '. Nearby players (100m): None' }
    end

    context 'when provided a ist of nearby players' do
      let(:event) { { nearby_players: %w(Player1 Player2) } }

      subject { uorpt.send(:nearby_players, event) }

      it { should be_an_instance_of String }

      it { should eql ". Nearby players (100m): ['Player1','Player2']" }
    end
  end

  describe '.beguid' do
    context 'when given more than one arg' do
      it 'should raise ArgumentError' do
        expect do
          uorpt.send(:beguid, nil, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when given less than one arg' do
      it 'should raise ArgumentError' do
        expect do
          uorpt.send(:beguid)
        end.to raise_error ArgumentError
      end
    end

    context 'when given a non-nil value' do
      subject { uorpt.send(:beguid, 'ohai') }

      it { should be_an_instance_of String }

      it { should eql ' (ohai)' }
    end

    context 'when given nil' do
      subject { uorpt.send(:beguid, nil) }

      it { should be_nil }
    end
  end

  describe '.format_died_ext' do
    context 'when given more than one arg' do
      it 'should raise ArgumentError' do
        expect do
          uorpt.send(:format_died_ext, nil, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when given less than one arg' do
      it 'should raise ArgumentError' do
        expect do
          uorpt.send(:format_died_ext)
        end.to raise_error ArgumentError
      end
    end

    context 'when given a death event' do
      let(:event) { { victim_position: 'x', victim_grid: '0x0' } }

      subject { uorpt.send(:format_died_ext, event) }

      it { should be_an_instance_of String }

      it { should eql ' at [x] (GRID 0x0)' }
    end
  end

  describe '.format_wounded_ext' do
    context 'when given more than one arg' do
      it 'should raise ArgumentError' do
        expect do
          uorpt.send(:format_wounded_ext, nil, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when given less than one arg' do
      it 'should raise ArgumentError' do
        expect do
          uorpt.send(:format_wounded_ext)
        end.to raise_error ArgumentError
      end
    end

    context 'when given a wounded event' do
      let(:event) { { damage: 9001 } }

      subject { uorpt.send(:format_wounded_ext, event) }

      it { should be_an_instance_of String }

      it { should eql ' for 9001 damage' }
    end
  end

  describe '.format_killed_ext' do
    context 'when given more than one arg' do
      it 'should raise ArgumentError' do
        expect do
          uorpt.send(:format_killed_ext, nil, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when given less than one arg' do
      it 'should raise ArgumentError' do
        expect do
          uorpt.send(:format_killed_ext)
        end.to raise_error ArgumentError
      end
    end

    context 'when given a killed event' do
      let(:event) do
        {
          victim: 'x', victim_position: '0', victim_grid: '00', offender: 'y',
          offender_position: '1', offender_grid: '11', distance: '42'
        }
      end

      subject { uorpt.send(:format_killed_ext, event) }

      it { should be_an_instance_of String }

      it do
        should eql(
          '. x pos: [0] (GRID 00). y pos: [1] (GRID 11). Distance between: 42m'
        )
      end
    end
  end

  describe '.format_announcement' do
    context 'when given more than one arg' do
      it 'should raise ArgumentError' do
        expect do
          uorpt.send(:format_announcement, nil, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when given less than one arg' do
      it 'should raise ArgumentError' do
        expect do
          uorpt.send(:format_announcement)
        end.to raise_error ArgumentError
      end
    end

    context 'when given an announcement event' do
      let(:event) { { head: '#', tail: '##', message: 'ohai' } }

      subject { uorpt.send(:format_announcement, event) }

      it { should be_an_instance_of String }

      it { should eql "z \"# ohai ##\"\n" }
    end
  end

  describe '.format_died' do
    let(:event) { { victim: 'x' } }

    context 'when given more than one arg' do
      it 'should raise ArgumentError' do
        expect do
          uorpt.send(:format_died, nil, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when given less than one arg' do
      it 'should raise ArgumentError' do
        expect do
          uorpt.send(:format_died)
        end.to raise_error ArgumentError
      end
    end

    context 'when the event has a beguid for victim' do
      before do
        uorpt.instance_variable_set(:@level, :simple)
      end
      let(:event) { { victim: 'x', victim_beguid: 'abc' } }

      subject { uorpt.send(:format_died, event) }

      it { should be_an_instance_of String }

      it { should eql "zt x (abc) has bled out or died of pain\"\n" }
    end

    context 'when @level is :simple' do
      before { uorpt.instance_variable_set(:@level, :simple) }

      subject { uorpt.send(:format_died, event) }

      it { should be_an_instance_of String }

      it { should eql "zt x has bled out or died of pain\"\n" }
    end

    context 'when @level is :ext' do
      before do
        uorpt.instance_variable_set(:@level, :ext)
        allow(uorpt).to receive(:format_died_ext).and_return(' z')
      end

      subject { uorpt.send(:format_died, event) }

      it { should be_an_instance_of String }

      it { should eql "zt x has bled out or died of pain z\"\n" }

      it 'should call the .format_died_ext' do
        expect(uorpt).to receive(:format_died_ext).with(event)
          .and_return(' z')

        expect(uorpt.send(:format_died, event)).to be_an_instance_of String
      end
    end

    context 'when @level is :full' do
      before do
        uorpt.instance_variable_set(:@level, :full)
        allow(uorpt).to receive(:format_died_ext).and_return(' z')
        allow(uorpt).to receive(:nearby_players).and_return(' y')
      end

      subject { uorpt.send(:format_died, event) }

      it { should be_an_instance_of String }

      it { should eql "zt x has bled out or died of pain z y\"\n" }

      it 'should call the .format_died_ext' do
        expect(uorpt).to receive(:format_died_ext).with(event)
          .and_return(' z')

        expect(uorpt.send(:format_died, event)).to be_an_instance_of String
      end

      it 'should call the .nearby_players' do
        expect(uorpt).to receive(:nearby_players).with(event)
          .and_return(' y')

        expect(uorpt.send(:format_died, event)).to be_an_instance_of String
      end
    end
  end

  describe '.format_killed' do
    let(:event) do
      { victim: 'x', victim_team: 'b', offender: 'y', offender_team: 'o' }
    end

    context 'when given more than one arg' do
      it 'should raise ArgumentError' do
        expect do
          uorpt.send(:format_killed, nil, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when given less than one arg' do
      it 'should raise ArgumentError' do
        expect do
          uorpt.send(:format_killed)
        end.to raise_error ArgumentError
      end
    end

    context 'when the event has a beguid for both players' do
      before do
        uorpt.instance_variable_set(:@level, :simple)
      end
      let(:event) do
        {
          victim: 'x', victim_team: 'b', offender: 'y', offender_team: 'o',
          victim_beguid: 'abc', offender_beguid: '123'
        }
      end

      subject { uorpt.send(:format_killed, event) }

      it { should be_an_instance_of String }

      it { should eql "zt x (abc) (b) has been killed by y (123) (o)\"\n" }
    end

    context 'when the event has a beguid for the victim' do
      before do
        uorpt.instance_variable_set(:@level, :simple)
      end
      let(:event) do
        {
          victim: 'x', victim_team: 'b', offender: 'y', offender_team: 'o',
          victim_beguid: 'abc'
        }
      end

      subject { uorpt.send(:format_killed, event) }

      it { should be_an_instance_of String }

      it { should eql "zt x (abc) (b) has been killed by y (o)\"\n" }
    end

    context 'when the event has a beguid for the offender' do
      before do
        uorpt.instance_variable_set(:@level, :simple)
      end
      let(:event) do
        {
          victim: 'x', victim_team: 'b', offender: 'y', offender_team: 'o',
          offender_beguid: '123'
        }
      end

      subject { uorpt.send(:format_killed, event) }

      it { should be_an_instance_of String }

      it { should eql "zt x (b) has been killed by y (123) (o)\"\n" }
    end

    context 'when @level is :simple' do
      before { uorpt.instance_variable_set(:@level, :simple) }

      subject { uorpt.send(:format_killed, event) }

      it { should be_an_instance_of String }

      it { should eql "zt x (b) has been killed by y (o)\"\n" }
    end

    context 'when @level is :ext' do
      before do
        uorpt.instance_variable_set(:@level, :ext)
        allow(uorpt).to receive(:format_killed_ext).and_return(' k')
      end

      subject { uorpt.send(:format_killed, event) }

      it { should be_an_instance_of String }

      it { should eql "zt x (b) has been killed by y (o) k\"\n" }

      it 'should call .format_killed_ext' do
        expect(uorpt).to receive(:format_killed_ext).with(event)
          .and_return(' k')

        expect(uorpt.send(:format_killed, event)).to be_an_instance_of String
      end
    end

    context 'when @level is :full' do
      before do
        uorpt.instance_variable_set(:@level, :full)
        allow(uorpt).to receive(:format_killed_ext).and_return(' k')
        allow(uorpt).to receive(:nearby_players).and_return(' p')
      end

      subject { uorpt.send(:format_killed, event) }

      it { should be_an_instance_of String }

      it { should eql "zt x (b) has been killed by y (o) k p\"\n" }

      it 'should call .format_killed_ext' do
        expect(uorpt).to receive(:format_killed_ext).with(event)
          .and_return(' k')

        expect(uorpt.send(:format_killed, event)).to be_an_instance_of String
      end

      it 'should call .nearby_players' do
        expect(uorpt).to receive(:nearby_players).with(event)
          .and_return(' p')

        expect(uorpt.send(:format_killed, event)).to be_an_instance_of String
      end
    end
  end

  describe '.format_wounded' do
    let(:event) do
      { victim: 'x', victim_team: 'b', offender: 'y', offender_team: 'o' }
    end

    context 'when given more than one arg' do
      it 'should raise ArgumentError' do
        expect do
          uorpt.send(:format_wounded, nil, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when given less than one arg' do
      it 'should raise ArgumentError' do
        expect do
          uorpt.send(:format_wounded)
        end.to raise_error ArgumentError
      end
    end

    context 'when the event has a beguid for both players' do
      before do
        uorpt.instance_variable_set(:@level, :simple)
      end
      let(:event) do
        {
          victim: 'x', victim_team: 'b', offender: 'y', offender_team: 'o',
          victim_beguid: 'abc', offender_beguid: '123'
        }
      end

      subject { uorpt.send(:format_wounded, event) }

      it { should be_an_instance_of String }

      it { should eql "zt x (abc) (b) has been wounded by y (123) (o)\"\n" }
    end

    context 'when the event has a beguid for only victim' do
      before do
        uorpt.instance_variable_set(:@level, :simple)
      end
      let(:event) do
        {
          victim: 'x', victim_team: 'b', offender: 'y', offender_team: 'o',
          victim_beguid: 'abc'
        }
      end

      subject { uorpt.send(:format_wounded, event) }

      it { should be_an_instance_of String }

      it { should eql "zt x (abc) (b) has been wounded by y (o)\"\n" }
    end

    context 'when the event has a beguid for only offender' do
      before do
        uorpt.instance_variable_set(:@level, :simple)
      end
      let(:event) do
        {
          victim: 'x', victim_team: 'b', offender: 'y', offender_team: 'o',
          offender_beguid: '123'
        }
      end

      subject { uorpt.send(:format_wounded, event) }

      it { should be_an_instance_of String }

      it { should eql "zt x (b) has been wounded by y (123) (o)\"\n" }
    end

    context 'when @level is :simple' do
      before { uorpt.instance_variable_set(:@level, :simple) }

      subject { uorpt.send(:format_wounded, event) }

      it { should be_an_instance_of String }

      it { should eql "zt x (b) has been wounded by y (o)\"\n" }
    end

    context 'when @level is :ext' do
      before do
        uorpt.instance_variable_set(:@level, :ext)
        allow(uorpt).to receive(:format_wounded_ext).and_return(' k')
      end

      subject { uorpt.send(:format_wounded, event) }

      it { should be_an_instance_of String }

      it { should eql "zt x (b) has been wounded by y (o) k\"\n" }

      it 'should call .format_wounded_ext' do
        expect(uorpt).to receive(:format_wounded_ext).with(event)
          .and_return(' k')

        expect(uorpt.send(:format_wounded, event)).to be_an_instance_of String
      end
    end

    context 'when @level is :full' do
      before do
        uorpt.instance_variable_set(:@level, :full)
        allow(uorpt).to receive(:format_wounded_ext).and_return(' k')
      end

      subject { uorpt.send(:format_wounded, event) }

      it { should be_an_instance_of String }

      it { should eql "zt x (b) has been wounded by y (o) k\"\n" }

      it 'should call .format_wounded_ext' do
        expect(uorpt).to receive(:format_wounded_ext).with(event)
          .and_return(' k')

        expect(uorpt.send(:format_wounded, event)).to be_an_instance_of String
      end
    end
  end

  describe '.format' do
    context 'when given more than two args' do
      it 'should raise ArgumentError' do
        expect do
          uorpt.format(nil, nil, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when given less than one arg' do
      it 'should raise ArgumentError' do
        expect do
          uorpt.format
        end.to raise_error ArgumentError
      end
    end

    context 'always' do
      it 'should call .validate_and_set_level' do
        expect(uorpt).to receive(:validate_and_set_level).with(:ohai)
          .and_return(nil)
        uorpt.format({ type: :x }, :ohai)
      end
    end

    context 'when a :wounded event' do
      let(:event) { { type: :wounded } }

      it 'should call format_wounded with the event' do
        expect(uorpt).to receive(:format_wounded).with(event)
          .and_return(:hello)
        expect(uorpt.format(event)).to eql :hello
      end
    end

    context 'when a :killed event' do
      let(:event) { { type: :killed } }

      it 'should call format_killed with the event' do
        expect(uorpt).to receive(:format_killed).with(event)
          .and_return(:hullo)
        expect(uorpt.format(event)).to eql :hullo
      end
    end

    context 'when a :died event' do
      let(:event) { { type: :died } }

      it 'should call format_died with the event' do
        expect(uorpt).to receive(:format_died).with(event)
          .and_return(:hallo)
        expect(uorpt.format(event)).to eql :hallo
      end
    end

    context 'when an :announcement event' do
      let(:event) { { type: :announcement } }

      it 'should call format_announcement with the event' do
        expect(uorpt).to receive(:format_announcement).with(event)
          .and_return(:ugh)
        expect(uorpt.format(event)).to eql :ugh
      end
    end

    context 'when an :unknown event' do
      let(:event) { { type: :something } }

      subject { uorpt.format(event) }

      it { should be_nil }
    end
  end
end
