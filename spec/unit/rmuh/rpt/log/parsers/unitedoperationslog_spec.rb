# -*- coding: UTF-8 -*-
require 'stringio'
require 'tzinfo'

describe RMuh::RPT::Log::Parsers::UnitedOperationsLog do
  let(:uolog) { RMuh::RPT::Log::Parsers::UnitedOperationsLog.new }

  context '::validate_opts' do
    it 'should take no more than one arg' do
      expect do
        RMuh::RPT::Log::Parsers::UnitedOperationsLog.validate_opts(nil, nil)
      end.to raise_error ArgumentError
    end

    it 'should take no less than one arg' do
      expect do
        RMuh::RPT::Log::Parsers::UnitedOperationsLog.validate_opts
      end.to raise_error ArgumentError
    end

    it 'should return nil if arg 1 is a Hash' do
      expect(
        RMuh::RPT::Log::Parsers::UnitedOperationsLog.validate_opts({})
      ).to be_nil
    end

    it 'should fail if to_zulu is not boolean' do
      expect do
        RMuh::RPT::Log::Parsers::UnitedOperationsLog.validate_opts(to_zulu: {})
      end.to raise_error ArgumentError
    end

    it 'should fail if timezone is not TZInfo::DataTimezone' do
      expect do
        RMuh::RPT::Log::Parsers::UnitedOperationsLog
          .validate_opts(timezone: {})
      end.to raise_error ArgumentError
    end

    it 'should fail if chat is not boolean' do
      expect do
        RMuh::RPT::Log::Parsers::UnitedOperationsLog.validate_opts(chat: {})
      end.to raise_error ArgumentError
    end
  end

  context '::new' do
    it 'should not take more than one arg' do
      expect do
        RMuh::RPT::Log::Parsers::UnitedOperationsLog.new(nil, nil)
      end.to raise_error ArgumentError
    end

    it 'should fail if arg 1 is not a Hash' do
      expect do
        RMuh::RPT::Log::Parsers::UnitedOperationsLog.new(nil)
      end.to raise_error ArgumentError
    end

    it 'should return an instance of UnitedOperationsLog' do
      u = RMuh::RPT::Log::Parsers::UnitedOperationsLog.new
      expect(u)
        .to be_an_instance_of RMuh::RPT::Log::Parsers::UnitedOperationsLog
    end

    it 'should not include chat by default' do
      u = uolog.instance_variable_get(:@include_chat)
      expect(u).to be_falsey
    end

    it 'should convert to zulu by default' do
      u = uolog.instance_variable_get(:@to_zulu)
      expect(u).to be_truthy
    end

    it 'should use the UO timezone by default' do
      t = RMuh::RPT::Log::Util::UnitedOperations::UO_TZ
      u = uolog.instance_variable_get(:@timezone)
      expect(u).to eql t
    end

    it 'should not include chat if passed as false' do
      u = RMuh::RPT::Log::Parsers::UnitedOperationsLog.new(chat: false)
      expect(u.instance_variable_get(:@include_chat)).to eql false
    end

    it 'should include chat if passed as true' do
      u = RMuh::RPT::Log::Parsers::UnitedOperationsLog.new(chat: true)
      expect(u.instance_variable_get(:@include_chat)).to eql true
    end

    it 'should not convert to zulu if passed as false' do
      u = RMuh::RPT::Log::Parsers::UnitedOperationsLog.new(to_zulu: false)
      expect(u.instance_variable_get(:@to_zulu)).to eql false
    end

    it 'should convert to zulu if passed as true' do
      u = RMuh::RPT::Log::Parsers::UnitedOperationsLog.new(to_zulu: true)
      expect(u.instance_variable_get(:@to_zulu)).to eql true
    end

    it 'should specify a custom timezone if passed in' do
      t = TZInfo::Timezone.get('Etc/UTC')
      u = RMuh::RPT::Log::Parsers::UnitedOperationsLog.new(timezone: t)
      expect(u.instance_variable_get(:@timezone)).to eql t
    end
  end

  context '#date_of_line_based_on_now' do
    it 'should take no more than one arg' do
      expect do
        uolog.send(:date_of_line_based_on_now, nil, nil)
      end.to raise_error ArgumentError
    end

    it 'should return today if it is between 0400 and 2359' do
      tz = RMuh::RPT::Log::Util::UnitedOperations::UO_TZ
      t = Time.new(2014, 1, 1, 4, 0, 0)
      expect(uolog.send(:date_of_line_based_on_now, t).to_s).to eql tz.now.to_s
      t = Time.new(2014, 1, 1, 23, 59, 59)
      expect(uolog.send(:date_of_line_based_on_now, t).to_s).to eql tz.now.to_s
      t = Time.new(2014, 1, 1, 0, 0, 0)
      expect(uolog.send(:date_of_line_based_on_now, t).to_s)
        .to_not eql tz.now.to_s
    end

    it 'should return yesterday if it is between 0000 and 0359' do
      tz = RMuh::RPT::Log::Util::UnitedOperations::UO_TZ
      d = RMuh::RPT::Log::Util::UnitedOperationsLog::ONE_DAY
      t = Time.new(2014, 1, 1, 0, 0, 0)
      expect(uolog.send(:date_of_line_based_on_now, t).to_s)
        .to eql((tz.now - d).to_s)
      t = Time.new(2014, 1, 1, 3, 59, 59)
      expect(uolog.send(:date_of_line_based_on_now, t).to_s)
        .to eql((tz.now - d).to_s)
      t = Time.new(2014, 1, 1, 4, 0, 0)
      expect(uolog.send(:date_of_line_based_on_now, t).to_s)
        .to_not eql((tz.now - d).to_s)
    end
  end

  context '#set_line_date!' do
    it 'should not take more than two args' do
      expect do
        uolog.send(:set_line_date!, nil, nil, nil)
      end.to raise_error ArgumentError
    end

    it 'should not take less than one arg' do
      expect do
        uolog.send(:set_line_date!)
      end.to raise_error ArgumentError
    end

    it "should set the line's year to this year" do
      tz = uolog.instance_variable_get(:@timezone)
      l = {}
      uolog.send(:set_line_date!, l)
      expect(l[:year]).to eql tz.now.year
    end

    it "should set the line's month to this month" do
      tz = uolog.instance_variable_get(:@timezone)
      l = {}
      uolog.send(:set_line_date!, l)
      expect(l[:month]).to eql tz.now.month
    end

    it "should set the line's date to this day" do
      tz = uolog.instance_variable_get(:@timezone)
      l = {}
      uolog.send(:set_line_date!, l)
      expect(l[:day]).to eql tz.now.day
    end
  end

  context '#when_am_i!' do
    let(:yday_line) { { hour: 4, min: 0, sec: 0 } }
    let(:today_line) { { hour: 0, min: 0, sec: 0 } }

    it 'should take no more than one arg' do
      expect do
        uolog.send(:when_am_i!, nil, nil)
      end.to raise_error ArgumentError
    end

    it 'should take no less than one arg' do
      expect do
        uolog.send(:when_am_i!)
      end.to raise_error ArgumentError
    end

    it 'should set date as today if line (0400-2359) and now same range ' do
      tz = uolog.instance_variable_get(:@timezone)
      l = yday_line.dup
      allow(uolog).to receive(:date_of_line_based_on_now).and_return(tz.now)
      uolog.send(:when_am_i!, l)
      expect(l[:year]).to eql tz.now.year
      expect(l[:month]).to eql tz.now.month
      expect(l[:day]).to eql tz.now.day
    end

    it 'should set the date as yday if line (0400-2359) now not same range' do
      d = RMuh::RPT::Log::Util::UnitedOperationsLog::ONE_DAY
      tz = uolog.instance_variable_get(:@timezone)
      l = yday_line.dup
      allow(uolog).to receive(:date_of_line_based_on_now)
        .and_return(tz.now - d)
      uolog.send(:when_am_i!, l)
      expect(l[:year]).to eql((tz.now - d).year)
      expect(l[:month]).to eql((tz.now - d).month)
      expect(l[:day]).to eql((tz.now - d).day)
    end

    it 'should set the date as today if time between 0000 and 0359' do
      tz = uolog.instance_variable_get(:@timezone)
      l = today_line.dup
      uolog.send(:when_am_i!, l)
      expect(l[:year]).to eql tz.now.year
      expect(l[:month]).to eql tz.now.month
      expect(l[:day]).to eql tz.now.day
    end
  end

  context '#line_modifiers' do
    it 'should take no more than one arg' do
      expect do
        uolog.send(:line_modifiers, nil, nil)
      end.to raise_error ArgumentError
    end

    it 'should take no less than one arg' do
      expect do
        uolog.send(:line_modifiers)
      end.to raise_error ArgumentError
    end

    it 'should call where_am_i! and set the year/month/day' do
      l = { hour: 4, min: 0, sec: 0 }
      x = uolog.send(:line_modifiers, l)
      expect(x.key?(:year)).to be_truthy
      expect(x.key?(:month)).to be_truthy
      expect(x.key?(:day)).to be_truthy
    end

    it 'sould call zulu! and set the time to zulu' do
      l = { hour: 4, min: 0, sec: 0 }
      x = uolog.send(:line_modifiers, l)
      expect(x.key?(:iso8601)).to be_truthy
      expect(x.key?(:dtg)).to be_truthy
    end

    it 'should call add_guid! and add the event_guid' do
      l = { hour: 4, min: 0, sec: 0 }
      x = uolog.send(:line_modifiers, l)
      expect(x.key?(:event_guid)).to be_truthy
    end

    context 'when a user join event' do
      it 'should call strip_port!' do
        l = { hour: 4, min: 0, sec: 0, type: :connect, net: '127.0.0.1:443' }
        x = uolog.send(:line_modifiers, l)
        expect(x.key?(:ipaddr)).to be_truthy
        expect(x.key?(:net)).to be_falsey
      end
    end

    context 'when not a user joint event' do
      it 'should not call strip_port!' do
        l = { hour: 4, min: 0, sec: 0, type: :x, net: '127.0.0.1:443' }
        x = uolog.send(:line_modifiers, l)
        expect(x.key?(:net)).to be_truthy
      end
    end
  end

  context '#regex_matches' do
    let(:uolog) do
      RMuh::RPT::Log::Parsers::UnitedOperationsLog.new(chat: true)
    end
    let(:guid_line) do
      ' 4:01:51 BattlEye Server: Verified GUID (a0fbee2a02992c8cafabe67e0675' \
      'cea7) of player #0 stebbi92 '
    end
    let(:chat_line) do
      "6:58:25 BattlEye Server: (Side) Major Lee Payne: I'm up, " \
      "radio doesn't work"
    end
    let(:loglines) { StringIO.new("#{guid_line}\n#{chat_line}\n") }

    it 'should take no more than one arg' do
      expect do
        uolog.send(:regex_matches, nil, nil)
      end.to raise_error ArgumentError
    end

    it 'should take no less than one arg' do
      expect do
        uolog.send(:regex_matches)
      end.to raise_error ArgumentError
    end

    it 'should return an Array' do
      expect(uolog.send(:regex_matches, StringIO.new))
        .to be_an_instance_of Array
    end

    it 'should iterate over multiple log lines' do
      x = uolog.send(:regex_matches, loglines)
      expect(x).to be_an_instance_of Array
      expect(x.length).to eql 2
    end

    it 'should properly match a guid line' do
      x = uolog.send(:regex_matches, StringIO.new(guid_line))
      expect(x[0][:type]).to eql :beguid
    end

    it 'should properly match a chat line' do
      x = uolog.send(:regex_matches, StringIO.new(chat_line))
      expect(x[0][:type]).to eql :chat
    end

    it 'should not match a chat line if chat matching is disabled' do
      u = RMuh::RPT::Log::Parsers::UnitedOperationsLog.new
      expect(
        u.send(:regex_matches, StringIO.new(chat_line)).empty?
      ).to be_truthy
    end

    it 'should compact the Array' do
      l = StringIO.new("Something1\nSomething2\n")
      x = uolog.send(:regex_matches, l)
      expect(x.include?(nil)).to be_falsey
    end

    it 'should call #line_modifiers' do
      x = uolog.send(:regex_matches, StringIO.new(guid_line))
      expect(x[0].key?(:year)).to be_truthy
      expect(x[0].key?(:month)).to be_truthy
      expect(x[0].key?(:day)).to be_truthy
      expect(x[0].key?(:iso8601)).to be_truthy
      expect(x[0].key?(:dtg)).to be_truthy
      expect(x[0].key?(:event_guid)).to be_truthy
    end
  end

  context '#parse' do
    let(:guid_line) do
      ' 4:01:51 BattlEye Server: Verified GUID (a0fbee2a02992c8cafabe67e0675' \
      'cea7) of player #0 stebbi92 '
    end

    it 'should take no more than one arg' do
      expect { uolog.parse(nil, nil) }.to raise_error ArgumentError
    end

    it 'should take no less than one arg' do
      expect { uolog.parse }.to raise_error ArgumentError
    end

    it 'should not fail if arg1 is a StringIO object' do
      expect { uolog.parse(StringIO.new) }.to_not raise_error
    end

    it 'should fail if arg1 is a String' do
      expect { uolog.parse('') }.to raise_error ArgumentError
    end

    it 'should fail if arg1 is a Symbol' do
      expect { uolog.parse(:x) }.to raise_error ArgumentError
    end

    it 'should fail if arg1 is a Fixnum' do
      expect { uolog.parse(0) }.to raise_error ArgumentError
    end

    it 'should fail if arg1 is a Float' do
      expect { uolog.parse(0.0) }.to raise_error ArgumentError
    end

    it 'should fail if arg1 is a Array' do
      expect { uolog.parse([]) }.to raise_error ArgumentError
    end

    it 'should fail if arg1 is a Hash' do
      expect { uolog.parse({}) }.to raise_error ArgumentError
    end

    it 'should fail if arg1 is nil' do
      expect { uolog.parse(nil) }.to raise_error ArgumentError
    end

    it 'should return an Array' do
      expect(uolog.parse(StringIO.new)).to be_an_instance_of Array
    end

    it 'should call #regex_matches' do
      x = uolog.parse(StringIO.new(guid_line))
      expect(x[0].key?(:type)).to be_truthy
      expect(x[0].key?(:year)).to be_truthy
      expect(x[0].key?(:month)).to be_truthy
      expect(x[0].key?(:day)).to be_truthy
      expect(x[0].key?(:iso8601)).to be_truthy
      expect(x[0].key?(:dtg)).to be_truthy
      expect(x[0].key?(:event_guid)).to be_truthy
    end
  end
end
