# -*- coding: UTF-8 -*-
require 'rspec'
require 'tzinfo'
require 'helpers/unitedoperations'

describe RMuh::RPT::Log::Util::UnitedOperations do
  before(:all) do
    @uo_util = Class.new
    @uo_util.extend(RMuh::RPT::Log::Util::UnitedOperations)
    @mi = Regexp.new(
      '(?<year>\d+)/(?<month>\d+)/(?<day>\d+)'\
      '\s(?<hour>\d+):(?<min>\d+):(?<sec>\d+)\s(?<player_num>\d+)'
    )
    @mf = Regexp.new(
      '(?<server_time>[0-9.]+)\s(?<damage>[0-9.]+)\s(?<distance>[0-9.]+)'
    )
    @ma = /(?:(?<nearby_players>None.|\[.*?\])")/
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
      t = utc.local_to_utc(Time.new(2014, 01, 01, 00, 00, 00))
      t.strftime('%Y-%m-%dT%H:%M:%SZ')
    end
    let(:zulued) do
      ml = @uo_util.m_to_h(@mi.match('2013/12/31 16:00:00 0'))
      @uo_util.zulu!(ml, uo_tz)
    end

    it 'should not take more than three arguments' do
      expect { @uo_util.zulu!({}, nil, nil) }.to raise_error ArgumentError
    end

    it 'should not take less than two arguments' do
      expect { @uo_util.zulu! }.to raise_error ArgumentError
    end

    it 'should return a Hash' do
      ml = @uo_util.m_to_h(@mi.match('2013/12/31 16:00:00 0'))
      mr = @uo_util.zulu!(ml, uo_tz)
      expect(mr).to be_an_instance_of Hash
    end

    it 'should properly convert the time to zulu' do
      expect(zulued[:iso8601]).to eql good_time
    end

    it 'should properly format the time in iso8601' do
      m = /^\d+-\d+-\d+T\d+:\d+:\d+Z$/
      expect(m.match(zulued[:iso8601])).to be_an_instance_of MatchData
    end

    it 'should properly format the time in DTG' do
      m = /^\d+Z\s([A-Z]){3}\s\d+$/
      expect(m.match(zulued[:dtg])).to be_an_instance_of MatchData
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
      expect(@uo_util.__guid_data_base(@full_line)).to be_an_instance_of String
    end

    it 'should return a String if key :iso8608 is missing' do
      expect(@uo_util.__guid_data_base(fline)).to be_an_instance_of String
    end

    it 'should return iso8601 + type if key :is8601 is there' do
      x = @uo_util.__guid_data_base(@full_line)
      expect(x).to eql "#{@full_line[:iso8601]}#{@full_line[:type]}"
    end

    it 'should be year + month + day + hr + min + sec + type if !iso8601' do
      x = @uo_util.__guid_data_base(fline)
      s = "#{fline[:year]}#{fline[:month]}#{fline[:day]}#{fline[:hour]}" \
          "#{fline[:min]}#{fline[:sec]}#{fline[:type]}"
      expect(x).to eql s
    end
  end

  context '#__guid_add_data' do
    it 'should not take more than two args' do
      expect do
        @uo_util.__guid_add_data(nil, nil, nil)
      end.to raise_error ArgumentError
    end

    it 'should not take less than two args' do
      expect do
        @uo_util.__guid_add_data(nil)
      end.to raise_error ArgumentError
    end

    it 'should return a String' do
      l = {}
      expect(@uo_util.__guid_add_data(l, :year)).to be_an_instance_of String
    end

    it 'should return the key you requested by as a String' do
      l = { year: 2014 }
      expect(@uo_util.__guid_add_data(l, :year)).to eql '2014'
    end

    it 'should return an empty String if the key does not exist' do
      l = { year: 2014 }
      expect(@uo_util.__guid_add_data(l, :month)).to eql ''
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
      expect(@uo_util.add_guid!(@full_line)).to be_an_instance_of Hash
    end

    it 'should return a Hash that matches the reference' do
      expect(@uo_util.add_guid!(@full_line)).to eql guid_line
    end

    it 'should properly set the :event_guid for killed' do
      x = @uo_util.add_guid!(spec_killed_line)
      y = spec_guid_reference_implementation(spec_killed_line)
      expect(x.key?(:event_guid)).to be_truthy
      expect(x[:event_guid]).to eql y[:event_guid]
    end

    it 'should properly set the :event_guid for died' do
      x = @uo_util.add_guid!(spec_died_line)
      y = spec_guid_reference_implementation(spec_died_line)
      expect(x.key?(:event_guid)).to be_truthy
      expect(y[:event_guid]).to eql y[:event_guid]
    end

    it 'should properly set the :event_guid for wounded' do
      x = @uo_util.add_guid!(spec_wounded_line)
      y = spec_guid_reference_implementation(spec_wounded_line)
      expect(x.key?(:event_guid)).to be_truthy
      expect(x[:event_guid]).to eql y[:event_guid]
    end

    it 'should properly set the :event_guid for announcements' do
      x = @uo_util.add_guid!(spec_announcement_line)
      y = spec_guid_reference_implementation(spec_announcement_line)
      expect(x.key?(:event_guid)).to be_truthy
      expect(x[:event_guid]).to eql y[:event_guid]
    end

    it 'should properly set the :event_guid for beguid' do
      x = @uo_util.add_guid!(spec_beguid_line)
      y = spec_guid_reference_implementation(spec_beguid_line)
      expect(x.key?(:event_guid)).to be_truthy
      expect(x[:event_guid]).to eql y[:event_guid]
    end

    it 'should properly set the :event_guid for chat' do
      x = @uo_util.add_guid!(spec_chat_line)
      y = spec_guid_reference_implementation(spec_chat_line)
      expect(x.key?(:event_guid)).to be_truthy
      expect(x[:event_guid]).to eql y[:event_guid]
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
      %w( server_time damage distance ).each do |m|
        x = @uo_util.__modifiers(md, m)
        expect(x).to be_an_instance_of Float
        expect(x).to eql md[m].to_f
      end
    end

    it 'should convert channel to lowercase' do
      chat = 'Group'
      md = /(?<channel>.*)/.match(chat)
      x = @uo_util.__modifiers(md, 'channel')
      expect(x).to be_an_instance_of String
      expect(/[[:lower:]]+/.match(x)).to_not be_nil
      expect(x).to eql chat.downcase
    end

    it 'should convert the nearby players to Array' do
      md = @ma.match('["one","two","three"]"')
      x = @uo_util.__modifiers(md, 'nearby_players')
      expect(x).to be_an_instance_of Array
      expect(x.length).to be 3
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
      md = @mi.match('2014/02/09 14:44:44 0')
      %w( year month day hour min sec player_num ).each do |m|
        x = @uo_util.__line_modifiers(md, m)
        expect(x).to be_an_instance_of Fixnum
        expect(x).to eql md[m].to_i
      end
    end

    it 'should convert the correct values to Float' do
      md = @mf.match('2321.3 0.342 123.45')
      %w( server_time damage distance ).each do |m|
        x = @uo_util.__modifiers(md, m)
        expect(x).to be_an_instance_of Float
        expect(x).to eql md[m].to_f
      end
    end

    it 'should return the the match itself if the matcher is not recognized' do
      d = '042ZYK'
      md = /(?<something>.*)/.match(d)
      x = @uo_util.__line_modifiers(md, 'something')
      expect(x).to be_an_instance_of md['something'].class
      expect(x).to eql md['something']
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
      expect(h).to be_an_instance_of Hash
    end

    it 'should properly convert the correct values to int' do
      md = @mi.match('2014/02/09 14:44:44 0')
      h = @uo_util.m_to_h(md)
      [:year, :month, :day, :hour, :min, :sec].each do |m|
        expect(h[m]).to be_an_instance_of Fixnum
      end
    end

    it 'should properly convert the correct values to float' do
      md = @mf.match('2321.3 0.342 123.45')
      h = @uo_util.m_to_h(md)
      [:server_time, :damage, :distance].each do |m|
        expect(h[m]).to be_an_instance_of Float
      end
    end

    it 'should convert the nearby players to an Array of Strings' do
      md = @ma.match('["one","two","three"]"')
      h = @uo_util.m_to_h(md)
      expect(h[:nearby_players]).to be_an_instance_of Array
      expect(h[:nearby_players].length).to be 3

      h[:nearby_players].each do |p|
        expect(p).to be_an_instance_of String
        expect(p.empty?).to be false
      end
    end

    it 'should convert nearby players to an empty Array if it is None' do
      md = @ma.match('None."')
      h = @uo_util.m_to_h(md)
      expect(h[:nearby_players]).to be_an_instance_of Array
      expect(h[:nearby_players].empty?).to be_truthy
    end
  end

  context '#validate_bool_opt' do
    it 'should not take more than two args' do
      expect do
        @uo_util.validate_bool_opt(nil, nil, nil)
      end.to raise_error ArgumentError
    end

    it 'should not take less than two args' do
      expect do
        @uo_util.validate_bool_opt(nil)
      end.to raise_error ArgumentError
    end

    it 'should return nil if the key does not exist' do
      h = { one: 'two' }
      expect(@uo_util.validate_bool_opt(h, :two)).to be_nil
    end

    it 'should return nil if the key is true' do
      h = { x: true }
      expect(@uo_util.validate_bool_opt(h, :x)).to be_nil
    end

    it 'should return nil if the key is false' do
      h = { x: false }
      expect(@uo_util.validate_bool_opt(h, :x)).to be_nil
    end

    it 'should raise ArgumentError if the key is a String' do
      expect do
        @uo_util.validate_bool_opt({ x: '' }, :x)
      end.to raise_error ArgumentError
    end

    it 'should raise ArgumentError if the key is a Symbol' do
      expect do
        @uo_util.validate_bool_opt({ x: :x }, :x)
      end.to raise_error ArgumentError
    end

    it 'should raise ArgumentError if the key is a Fixnum' do
      expect do
        @uo_util.validate_bool_opt({ x: 0 }, :x)
      end.to raise_error ArgumentError
    end

    it 'should raise ArgumentError if the key is a Float' do
      expect do
        @uo_util.validate_bool_opt({ x: 0.0 }, :x)
      end.to raise_error ArgumentError
    end

    it 'should raise ArgumentError if the key is a Array' do
      expect do
        @uo_util.validate_bool_opt({ x: [] }, :x)
      end.to raise_error ArgumentError
    end

    it 'should raise ArgumentError if the key is a Hash' do
      expect do
        @uo_util.validate_bool_opt({ x: '' }, :x)
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
      expect(@uo_util.validate_timezone(timezone: uo_tz)).to be_nil
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
