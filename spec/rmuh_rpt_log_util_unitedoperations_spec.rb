# -*- coding: UTF-8 -*-
require 'rspec'
require 'tzinfo'
require 'helpers/spec_helper'
require File.join(repo_root, 'lib/rmuh/rpt/log/util/unitedoperations')
require 'helpers/unitedoperations'

describe RMuh::RPT::Log::Util::UnitedOperations do
  before(:all) do
    @uo_util = Class.new
    @uo_util.extend(RMuh::RPT::Log::Util::UnitedOperations)
    @mi = Regexp.new(
      '(?<year>\d+)/(?<month>\d+)/(?<day>\d+)'\
      '\s(?<hour>\d+):(?<min>\d+):(?<sec>\d+)'
    )
    @mf = Regexp.new(
      '(?<server_time>[0-9.]+)\s(?<damage>[0-9.]+)\s(?<distance>[0-9.]+)'
    )
    @ma = /(?:(?<nearby_players>None|\[.*?\])")/
    @full_line = {
      year: 2014, month: 1, day: 1, hour: 0, min: 0, sec: 0, type: :killed,
      victim: 'Player1', offender: 'Player2', server_time: 2042.0,
      distance: 42.0, damage: 42.0, player: 'Player1',
      player_beguid: 'abc123', channel: 'side', iso8601: '2014-01-01T00:00:00Z'
    }
  end

  context RMuh::RPT::Log::Util::UnitedOperations::UO_TZ do
    let(:tz) { TZInfo::Timezone.get('America/Log_Angeles') }
    let(:uo_tz) { RMuh::RPT::Log::Util::UnitedOperations::UO_TZ }

    it 'should be an instance of TZInfo::DataTimezone' do
      expect(uo_tz).to be_an_instance_of TZInfo::DataTimezone
    end

    it 'should default to America/Los_Angeles' do
      expect(uo_tz).to eql TZInfo::Timezone.get('America/Los_Angeles')
    end
  end

  context '#zulu!' do
    let(:uo_tz) { RMuh::RPT::Log::Util::UnitedOperations::UO_TZ }
    let(:good_time) do
      utc = TZInfo::Timezone.get('Etc/UTC')
      utc.local_to_utc(Time.new(2014, 01, 01, 00, 00, 00)).iso8601
    end
    let(:zulued) do
      ml = @uo_util.m_to_h(@mi.match('2013/12/31 16:00:00'))
      @uo_util.zulu!(ml, uo_tz)
    end

    it 'should not take more than three arguments' do
      expect { @uo_util.zulu!({}, nil, nil) }.to raise_error ArgumentError
    end

    it 'should not take less than two arguments' do
      expect { @uo_util.zulu! }.to raise_error ArgumentError
    end

    it 'should return a Hash' do
      ml = @uo_util.m_to_h(@mi.match('2013/12/31 16:00:00'))
      mr = @uo_util.zulu!(ml, uo_tz)
      mr.should be_an_instance_of Hash
    end

    it 'should properly convert the time to zulu' do
      zulued[:iso8601].should eql good_time
    end

    it 'should properly format the time in iso8601' do
      m = /^\d+-\d+-\d+T\d+:\d+:\d+Z$/
      m.match(zulued[:iso8601]).should be_an_instance_of MatchData
    end

    it 'should properly format the time in DTG' do
      m = /^\d+Z\s([A-Z]){3}\s\d+$/
      m.match(zulued[:dtg]).should be_an_instance_of MatchData
    end
  end

  context '#__guid_data_base' do
    let(:fline) do
      x = @full_line.dup
      x.delete(:iso8601)
      x
    end
    it 'should not take more than one arg' do
      expect do
        @uo_util.__guid_data_base(nil, nil)
      end.to raise_error ArgumentError
    end

    it 'should not take less than one arg' do
      expect { @uo_util.__guid_data_base }.to raise_error ArgumentError
    end

    it 'should return a String if key :iso8601 is there' do
      @uo_util.__guid_data_base(@full_line).should be_an_instance_of String
    end

    it 'should return a String if key :iso8608 is missing' do
      @uo_util.__guid_data_base(fline).should be_an_instance_of String
    end

    it 'should return iso8601 + type if key :is8601 is there' do
      x = @uo_util.__guid_data_base(@full_line)
      x.should eql "#{@full_line[:iso8601]}#{@full_line[:type].to_s}"
    end

    it 'should be year + month + day + hr + min + sec + type if !iso8601' do
      x = @uo_util.__guid_data_base(fline)
      s = "#{fline[:year]}#{fline[:month]}#{fline[:day]}#{fline[:hour]}" \
          "#{fline[:min]}#{fline[:sec]}#{fline[:type].to_s}"
      x.should eql s
    end
  end

  context '#__guid_data_one' do
    it 'should not take more than one arg' do
      expect do
        @uo_util.__guid_data_one(nil, nil)
      end.to raise_error ArgumentError
    end

    it 'should not take less than one arg' do
      expect { @uo_util.__guid_data_one }.to raise_error ArgumentError
    end

    it 'should return a String' do
      @uo_util.__guid_data_one(@full_line).should be_an_instance_of String
    end

    it 'should be message + victim + offender + server_time + damage' do
      x = @uo_util.__guid_data_one(@full_line)
      s = "#{@full_line[:message].to_s}#{@full_line[:victim].to_s}" \
          "#{@full_line[:offender].to_s}#{@full_line[:server_time].to_s}" \
          "#{@full_line[:damage].to_s}"
      x.should eql s
    end
  end

  context '#__guid_data_two' do
    it 'should not take more than one arg' do
      expect do
        @uo_util.__guid_data_two(nil, nil)
      end.to raise_error ArgumentError
    end

    it 'should not take less than one arg' do
      expect { @uo_util.__guid_data_two }.to raise_error ArgumentError
    end

    it 'should return a String' do
      @uo_util.__guid_data_two(@full_line).should be_an_instance_of String
    end

    it 'should be distance + player + player_beguid + channel' do
      x = @uo_util.__guid_data_two(@full_line)
      s = "#{@full_line[:distance].to_s}#{@full_line[:player]}" \
          "#{@full_line[:player_beguid]}#{@full_line[:channel]}"
      x.should eql s
    end
  end

  context '#add_guid!' do
    let(:guid_line) { spec_guid_reference_implementation(@full_line) }

    it 'should not take more than one argument' do
      expect { @uo_util.add_guid!(nil, nil) }.to raise_error ArgumentError
    end

    it 'should not take less than one argument' do
      expect { @uo_util.add_guid! }.to raise_error ArgumentError
    end

    it 'should return a Hash' do
      @uo_util.add_guid!(@full_line).should be_an_instance_of Hash
    end

    it 'should return a Hash that matches the reference' do
      @uo_util.add_guid!(@full_line).should eql guid_line
    end

    it 'should properly set the :event_guid for killed' do
      x = @uo_util.add_guid!(spec_killed_line)
      y = spec_guid_reference_implementation(spec_killed_line)
      x.key?(:event_guid).should be_true
      x[:event_guid].should eql y[:event_guid]
    end

    it 'should properly set the :event_guid for died' do
      x = @uo_util.add_guid!(spec_died_line)
      y = spec_guid_reference_implementation(spec_died_line)
      x.key?(:event_guid).should be_true
      y[:event_guid].should eql y[:event_guid]
    end

    it 'should properly set the :event_guid for wounded' do
      x = @uo_util.add_guid!(spec_wounded_line)
      y = spec_guid_reference_implementation(spec_wounded_line)
      x.key?(:event_guid).should be_true
      x[:event_guid].should eql y[:event_guid]
    end

    it 'should properly set the :event_guid for announcements' do
      x = @uo_util.add_guid!(spec_announcement_line)
      y = spec_guid_reference_implementation(spec_announcement_line)
      x.key?(:event_guid).should be_true
      x[:event_guid].should eql y[:event_guid]
    end

    it 'should properly set the :event_guid for beguid' do
      x = @uo_util.add_guid!(spec_beguid_line)
      y = spec_guid_reference_implementation(spec_beguid_line)
      x.key?(:event_guid).should be_true
      x[:event_guid].should eql y[:event_guid]
    end

    it 'should properly set the :event_guid for chat' do
      x = @uo_util.add_guid!(spec_chat_line)
      y = spec_guid_reference_implementation(spec_chat_line)
      x.key?(:event_guid).should be_true
      x[:event_guid].should eql y[:event_guid]
    end
  end

  context '#__check_match_arg' do
    it 'should take at most one argument' do
      expect do
        @uo_util.__check_match_arg(nil, nil)
      end.to raise_error ArgumentError
    end

    it 'should take at least one argument' do
      expect { @uo_util.__check_match_arg }.to raise_error ArgumentError
    end

    it 'should raise ArgumentError if arg 1 is not a MatchData object' do
      expect { @uo_util.__check_match_arg(nil) }.to raise_error ArgumentError
    end
  end

  context '#__modifiers' do
    it 'should take at most two args' do
      expect do
        @uo_util.__modifiers(nil, nil, nil)
      end.to raise_error ArgumentError
    end

    it 'should take at least two args' do
      expect { @uo_util.__modifiers(nil) }.to raise_error ArgumentError
    end

    it 'should convert the correct values to Float' do
      md = @mf.match('2321.3 0.342 123.45')
      %w{server_time damage distance}.each do |m|
        x = @uo_util.__modifiers(md, m)
        x.should be_an_instance_of Float
        x.should eql md[m].to_f
      end
    end

    it 'should convert channel to lowercase' do
      chat = 'Group'
      md = /(?<channel>.*)/.match(chat)
      x = @uo_util.__modifiers(md, 'channel')
      x.should be_an_instance_of String
      /[[:lower:]]+/.match(x).should_not be_nil
      x.should eql chat.downcase
    end

    it 'should convert the nearby players to Array' do
      md = @ma.match('["one","two","three"]"')
      x = @uo_util.__modifiers(md, 'nearby_players')
      x.should be_an_instance_of Array
      x.length.should be 3
    end
  end

  context '#__line_modifiers' do
    it 'should take at most two args' do
      expect do
        @uo_util.__line_modifiers(nil, nil, nil)
      end.to raise_error ArgumentError
    end

    it 'should take at least two args' do
      expect { @uo_util.__line_modifiers(nil) }.to raise_error ArgumentError
    end

    it 'should convert the correct values to Fixnum' do
      md = @mi.match('2014/02/09 14:44:44')
      %w{year month day hour min sec}.each do |m|
        x = @uo_util.__line_modifiers(md, m)
        x.should be_an_instance_of Fixnum
        x.should eql md[m].to_i
      end
    end

    it 'should convert the correct values to Float' do
      md = @mf.match('2321.3 0.342 123.45')
      %w{server_time damage distance}.each do |m|
        x = @uo_util.__modifiers(md, m)
        x.should be_an_instance_of Float
        x.should eql md[m].to_f
      end
    end

    it 'should return the the match itself if the matcher is not recognized' do
      d = '042ZYK'
      md = /(?<something>.*)/.match(d)
      x = @uo_util.__line_modifiers(md, 'something')
      x.should be_an_instance_of md['something'].class
      x.should eql md['something']
    end
  end

  context '#m_to_h' do
    it 'should not take more than one argument' do
      expect { @uo_util.m_to_h(1, 2) }.to raise_error ArgumentError
    end

    it 'should not take less than one argument' do
      expect { @uo_util.m_to_h }.to raise_error ArgumentError
    end

    it 'should throw an exception if arg 1 is not a MatchData object' do
      expect { @uo_util.m_to_h(nil) }.to raise_error ArgumentError
    end

    it 'should return a Hash' do
      h = @uo_util.m_to_h(/.*/.match('thing'))
      h.should be_an_instance_of Hash
    end

    it 'should properly convert the correct values to int' do
      md = @mi.match('2014/02/09 14:44:44')
      h = @uo_util.m_to_h(md)
      [:year, :month, :day, :hour, :min, :sec].each do |m|
        h[m].should be_an_instance_of Fixnum
      end
    end

    it 'should properly convert the correct values to float' do
      md = @mf.match('2321.3 0.342 123.45')
      h = @uo_util.m_to_h(md)
      [:server_time, :damage, :distance].each do |m|
        h[m].should be_an_instance_of Float
      end
    end

    it 'should convert the nearby players to an Array of Strings' do
      md = @ma.match('["one","two","three"]"')
      h = @uo_util.m_to_h(md)
      h[:nearby_players].should be_an_instance_of Array
      h[:nearby_players].length.should be 3

      h[:nearby_players].each do |p|
        p.should be_an_instance_of String
        p.empty?.should be false
      end
    end

    it 'should convert nearby players to an empty Array if it is None' do
      md = @ma.match('None"')
      h = @uo_util.m_to_h(md)
      h[:nearby_players].should be_an_instance_of Array
      h[:nearby_players].empty?.should be_true
    end
  end

  context '#validate_to_zulu' do
    it 'should not take more than one arg' do
      expect do
        @uo_util.validate_to_zulu(nil, nil)
      end.to raise_error ArgumentError
    end

    it 'should not take less than one arg' do
      expect { @uo_util.validate_to_zulu }.to raise_error ArgumentError
    end

    it 'should return nil if arg 1 is true' do
      @uo_util.validate_to_zulu(to_zulu: true).should be_nil
    end

    it 'should return nil if arg 1 is false' do
      @uo_util.validate_to_zulu(to_zulu: false).should be_nil
    end

    it 'should raise ArgumentError if arg 1 is a String' do
      expect do
        @uo_util.validate_to_zulu(to_zulu: '')
      end.to raise_error ArgumentError
    end

    it 'should raise ArgumentError if arg 1 is a Symbol' do
      expect do
        @uo_util.validate_to_zulu(to_zulu: :x)
      end.to raise_error ArgumentError
    end

    it 'should raise ArgumentError if arg 1 is a Fixnum' do
      expect do
        @uo_util.validate_to_zulu(to_zulu: 0)
      end.to raise_error ArgumentError
    end

    it 'should raise ArgumentError if arg 1 is a Float' do
      expect do
        @uo_util.validate_to_zulu(to_zulu: 0.0)
      end.to raise_error ArgumentError
    end

    it 'should raise ArgumentError if arg 1 is an Array' do
      expect do
        @uo_util.validate_to_zulu(to_zulu: [])
      end.to raise_error ArgumentError
    end

    it 'should raise ArgumentError if arg 1 is a Hash' do
      expect do
        @uo_util.validate_to_zulu(to_zulu: {})
      end.to raise_error ArgumentError
    end
  end

  context '#validate_timezone' do
    let(:uo_tz) { RMuh::RPT::Log::Util::UnitedOperations::UO_TZ }

    it 'should not take more than one arg' do
      expect do
        @uo_util.validate_timezone(nil, nil)
      end.to raise_error ArgumentError
    end

    it 'should not take less than one arg' do
      expect { @uo_util.validate_timezone }.to raise_error ArgumentError
    end

    it 'should return nil if arg 1 is an instance of TZInfo::DataTimezone' do
      @uo_util.validate_timezone(timezone: uo_tz).should be_nil
    end

    it 'should raise ArgumentError if arg 1 is a String' do
      expect do
        @uo_util.validate_timezone(timezone: '')
      end.to raise_error ArgumentError
    end

    it 'should raise ArgumentError if arg 1 is a Symbol' do
      expect do
        @uo_util.validate_timezone(timezone: :x)
      end.to raise_error ArgumentError
    end

    it 'should raise ArgumentError if arg 1 is a Fixnum' do
      expect do
        @uo_util.validate_timezone(timezone: 0)
      end.to raise_error ArgumentError
    end

    it 'should raise ArgumentError if arg 1 is a Float' do
      expect do
        @uo_util.validate_timezone(timezone: 0.0)
      end.to raise_error ArgumentError
    end

    it 'should raise ArgumentError if arg 1 is an Array' do
      expect do
        @uo_util.validate_timezone(timezone: [])
      end.to raise_error ArgumentError
    end

    it 'should raise ArgumentError if arg 1 is a Hash' do
      expect do
        @uo_util.validate_timezone(timezone: {})
      end.to raise_error ArgumentError
    end
  end
end
