# -*- coding: UTF-8 -*-

describe RMuh::RPT::Log::Fetch do
  let(:url) do
    'https://raw2.github.com/theckman/rmuh/master/spec/files/content-length.' \
    'txt'
  end
  let(:fetch) { RMuh::RPT::Log::Fetch.new(url) }
  context '#new' do
    subject { fetch }

    it 'should return an instance of RMuh::RPT::Log::Fetch' do
      expect(fetch).to be_an_instance_of RMuh::RPT::Log::Fetch
    end

    it 'should have a @log_url object which is an instance of String' do
      expect(fetch.log_url).to be_an_instance_of String
    end

    it 'should set the "byte_start" config item if specified' do
      rlfetch = RMuh::RPT::Log::Fetch.new(url, byte_start: 10)
      expect(rlfetch.byte_start).to eql 10
    end

    it 'should set the "byte_end" config item if specified' do
      rlfetch = RMuh::RPT::Log::Fetch.new(url, byte_end: 42)
      expect(rlfetch.byte_end).to eql 42
    end
  end

  context '#byte_start' do
    it 'should allow setting the value to Integer' do
      expect { fetch.byte_start = 10 }.to_not raise_error
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
      expect(fetch.byte_start).to eql 10
    end
  end

  context '#byte_end' do
    it 'should allow setting the value to Integer' do
      expect { fetch.byte_end = 10 }.to_not raise_error
    end

    it 'should allow setting the value is nil' do
      expect { fetch.byte_end = nil }.to_not raise_error
    end

    it 'should raise an error if arg:1 is a String' do
      expect { fetch.byte_end = 'urmom' }.to raise_error ArgumentError
    end

    it 'should raise an error if arg:1 is a Float' do
      expect { fetch.byte_end = 4.2 }.to raise_error ArgumentError
    end

    it 'should update the @cfg.byte_end value' do
      fetch.byte_end = 42
      expect(fetch.byte_end).to eql 42
    end
  end

  context '#size' do
    it 'should return a Integer object' do
      expect(fetch.size).to be_an_instance_of Fixnum
    end

    it 'should return the size' do
      expect(fetch.size).to eql 10
    end
  end

  context '#log' do
    it 'should return an Array object' do
      expect(fetch.log).to be_an_instance_of Array
    end

    it 'should return the log' do
      expect(fetch.log.join('')).to eql 'RSpec, yo'
    end
  end

  context '#dos2unix' do
    let(:dos) { "text\r\n" }
    let(:dos_newline) { /\r\n$/ }

    it 'should match the Regexp object' do
      expect(dos_newline.match(dos)).to_not be nil
    end

    it 'should strip out DOS new lines' do
      match = /\r\n/.match(fetch.send(:dos2unix, dos))
      expect(match).to be_nil
    end
  end
end
