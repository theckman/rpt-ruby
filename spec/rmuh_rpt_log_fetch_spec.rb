require 'rspec'
require 'stringio'
require 'helpers/spec_helper'
require File.join(repo_root, 'lib/rmuh/rpt/log/fetch')

describe RMuh::RPT::Log::Fetch do
  let(:url) do
    'https://raw2.github.com/theckman/rmuh/master/spec/files/content-length.' \
    'txt'
  end
  let(:fetch) { RMuh::RPT::Log::Fetch.new(url) }
  context '#new' do
    it 'should return an instance of RMuh::RPT::Log::Fetch' do
      fetch.should be_an_instance_of RMuh::RPT::Log::Fetch
    end

    it 'should have a @cfg object which is an instance of OpenStruct' do
      fetch.cfg.should be_an_instance_of OpenStruct
    end

    it 'should set the "byte_start" config item if specified as arg:1' do
      rlfetch = RMuh::RPT::Log::Fetch.new(url, 10)
      rlfetch.cfg.byte_start.should eql 10
    end

    it 'should set the "byte_end" config item if specified as arg:3' do
      rlfetch = RMuh::RPT::Log::Fetch.new(url, 10, 42)
      rlfetch.cfg.byte_end.should eql 42
    end
  end

  context '#byte_start' do
    it 'should allow setting the value to Integer' do
      expect { fetch.byte_start = 10 }.not_to raise_error
    end

    it 'should raise an error if the value is nil' do
      expect { fetch.byte_start = nil }.to raise_error ArgumentError
    end

    it 'should raise an error if arg:1 is a String' do
      expect { fetch.byte_start = 'urmom' }.to raise_error ArgumentError
    end

    it 'should raise an error if arg:1 is a Float' do
      expect { fetch.byte_start = 4.2 }.to raise_error ArgumentError
    end

    it 'should update the @cfg.byte_start value' do
      fetch.byte_start = 10
      fetch.cfg.byte_start.should eql 10
    end
  end

  context '#byte_end' do
    it 'should allow setting the value to Integer' do
      expect { fetch.byte_end = 10 }.not_to raise_error
    end

    it 'should allow setting the value is nil' do
      expect { fetch.byte_end = nil }.not_to raise_error
    end

    it 'should raise an error if arg:1 is a String' do
      expect { fetch.byte_end = 'urmom' }.to raise_error ArgumentError
    end

    it 'should raise an error if arg:1 is a Float' do
      expect { fetch.byte_end = 4.2 }.to raise_error ArgumentError
    end

    it 'should update the @cfg.byte_end value' do
      fetch.byte_end = 42
      fetch.cfg.byte_end.should eql 42
    end
  end

  context '#size' do
    it 'should return a Integer object' do
      fetch.size.should be_an_instance_of Fixnum
    end

    it 'should return the size' do
      fetch.size.should eql 10
    end
  end

  context '#log' do
    it 'should return a StringIO object' do
      fetch.log.should be_an_instance_of StringIO
    end

    it 'should return the log' do
      fetch.log.read.should eql "RSpec, yo\n"
    end
  end

  context '#dos2unix' do
    let(:dos) { "text\r\n" }
    let(:dos_newline) { /\r\n$/ }

    it 'should match the Regexp object' do
      expect(dos_newline.match(dos)).not_to be nil
    end

    it 'should strip out DOS new lines' do
      match = /\r\n/.match(fetch.send(:dos2unix, dos))
      match.should be nil
    end
  end
end
