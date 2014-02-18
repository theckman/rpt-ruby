# -*- coding: UTF-8 -*-
require 'stringio'
require 'rspec'
require 'tzinfo'
require 'helpers/spec_helper'
require File.join(repo_root, 'lib/rmuh/rpt/log/util/unitedoperations')
require File.join(repo_root, 'lib/rmuh/rpt/log/util/unitedoperationslog')
require File.join(repo_root, 'lib/rmuh/rpt/log/parsers/unitedoperationslog')

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
      RMuh::RPT::Log::Parsers::UnitedOperationsLog.validate_opts({})
        .should be_nil
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
      u.should be_an_instance_of RMuh::RPT::Log::Parsers::UnitedOperationsLog
    end

    it 'should not include chat by default' do
      u = uolog.instance_variable_get(:@include_chat)
      u.should be_false
    end

    it 'should convert to zulu by default' do
      u = uolog.instance_variable_get(:@to_zulu)
      u.should be_true
    end

    it 'should use the UO timezone by default' do
      t = RMuh::RPT::Log::Util::UnitedOperations::UO_TZ
      u = uolog.instance_variable_get(:@timezone)
      u.should eql t
    end

    it 'should not include chat if passed as false' do
      u = RMuh::RPT::Log::Parsers::UnitedOperationsLog.new(chat: false)
      u.instance_variable_get(:@include_chat).should eql false
    end

    it 'should include chat if passed as true' do
      u = RMuh::RPT::Log::Parsers::UnitedOperationsLog.new(chat: true)
      u.instance_variable_get(:@include_chat).should eql true
    end

    it 'should not convert to zulu if passed as false' do
      u = RMuh::RPT::Log::Parsers::UnitedOperationsLog.new(to_zulu: false)
      u.instance_variable_get(:@to_zulu).should eql false
    end

    it 'should convert to zulu if passed as true' do
      u = RMuh::RPT::Log::Parsers::UnitedOperationsLog.new(to_zulu: true)
      u.instance_variable_get(:@to_zulu).should eql true
    end

    it 'should specify a custom timezone if passed in' do
      t = TZInfo::Timezone.get('Etc/UTC')
      u = RMuh::RPT::Log::Parsers::UnitedOperationsLog.new(timezone: t)
      u.instance_variable_get(:@timezone).should eql t
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
      uolog.send(:date_of_line_based_on_now, t).to_s.should eql tz.now.to_s
      t = Time.new(2014, 1, 1, 23, 59, 59)
      uolog.send(:date_of_line_based_on_now, t).to_s.should eql tz.now.to_s
      t = Time.new(2014, 1, 1, 0, 0, 0)
      uolog.send(:date_of_line_based_on_now, t).to_s.should_not eql tz.now.to_s
    end

    it 'should return yesterday if it is between 0000 and 0359' do
      tz = RMuh::RPT::Log::Util::UnitedOperations::UO_TZ
      d = RMuh::RPT::Log::Util::UnitedOperationsLog::ONE_DAY
      t = Time.new(2014, 1, 1, 0, 0, 0)
      uolog.send(:date_of_line_based_on_now, t)
        .to_s.should(eql((tz.now - d).to_s))
      t = Time.new(2014, 1, 1, 3, 59, 59)
      uolog.send(:date_of_line_based_on_now, t)
        .to_s.should(eql((tz.now - d).to_s))
      t = Time.new(2014, 1, 1, 4, 0, 0)
      uolog.send(:date_of_line_based_on_now, t)
        .to_s.should_not(eql((tz.now - d).to_s))
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
      l[:year].should eql tz.now.year
    end

    it "should set the line's month to this month" do
      tz = uolog.instance_variable_get(:@timezone)
      l = {}
      uolog.send(:set_line_date!, l)
      l[:month].should eql tz.now.month
    end

    it "should set the line's date to this day" do
      tz = uolog.instance_variable_get(:@timezone)
      l = {}
      uolog.send(:set_line_date!, l)
      l[:day].should eql tz.now.day
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
      uolog.stub(:date_of_line_based_on_now) { tz.now }
      uolog.send(:when_am_i!, l)
      l[:year].should eql tz.now.year
      l[:month].should eql tz.now.month
      l[:day].should eql tz.now.day
    end

    it 'should set the date as yday if line (0400-2359) now not same range' do
      d = RMuh::RPT::Log::Util::UnitedOperationsLog::ONE_DAY
      tz = uolog.instance_variable_get(:@timezone)
      l = yday_line.dup
      uolog.stub(:date_of_line_based_on_now) { tz.now - d }
      uolog.send(:when_am_i!, l)
      l[:year].should(eql((tz.now - d).year))
      l[:month].should(eql((tz.now - d).month))
      l[:day].should(eql((tz.now - d).day))
    end

    it 'should set the date as today if time between 0000 and 0359' do
      tz = uolog.instance_variable_get(:@timezone)
      l = today_line.dup
      uolog.send(:when_am_i!, l)
      l[:year].should eql tz.now.year
      l[:month].should eql tz.now.month
      l[:day].should eql tz.now.day
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
      x.key?(:year).should be_true
      x.key?(:month).should be_true
      x.key?(:day).should be_true
    end

    it 'sould call zulu! and set the time to zulu' do
      l = { hour: 4, min: 0, sec: 0 }
      x = uolog.send(:line_modifiers, l)
      x.key?(:iso8601).should be_true
      x.key?(:dtg).should be_true
    end

    it 'should call add_guid! and add the event_guid' do
      l = { hour: 4, min: 0, sec: 0 }
      x = uolog.send(:line_modifiers, l)
      x.key?(:event_guid).should be_true
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
      uolog.send(:regex_matches, StringIO.new).should be_an_instance_of Array
    end

    it 'should iterate over multiple log lines' do
      x = uolog.send(:regex_matches, loglines)
      x.should be_an_instance_of Array
      x.length.should eql 2
    end

    it 'should properly match a guid line' do
      x = uolog.send(:regex_matches, StringIO.new(guid_line))
      x[0][:type].should eql :beguid
    end

    it 'should properly match a chat line' do
      x = uolog.send(:regex_matches, StringIO.new(chat_line))
      x[0][:type].should eql :chat
    end

    it 'should not match a chat line if chat matching is disabled' do
      u = RMuh::RPT::Log::Parsers::UnitedOperationsLog.new
      u.send(:regex_matches, StringIO.new(chat_line)).empty?.should be_true
    end

    it 'should compact the Array' do
      l = StringIO.new("Something1\nSomething2\n")
      x = uolog.send(:regex_matches, l)
      x.include?(nil).should be_false
    end

    it 'should call #line_modifiers' do
      x = uolog.send(:regex_matches, StringIO.new(guid_line))
      x[0].key?(:year).should be_true
      x[0].key?(:month).should be_true
      x[0].key?(:day).should be_true
      x[0].key?(:iso8601).should be_true
      x[0].key?(:dtg).should be_true
      x[0].key?(:event_guid).should be_true
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
      expect { uolog.parse(StringIO.new) }.not_to raise_error
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
      uolog.parse(StringIO.new).should be_an_instance_of Array
    end

    it 'should call #regex_matches' do
      x = uolog.parse(StringIO.new(guid_line))
      x[0].key?(:type).should be_true
      x[0].key?(:year).should be_true
      x[0].key?(:month).should be_true
      x[0].key?(:day).should be_true
      x[0].key?(:iso8601).should be_true
      x[0].key?(:dtg).should be_true
      x[0].key?(:event_guid).should be_true
    end
  end
end
