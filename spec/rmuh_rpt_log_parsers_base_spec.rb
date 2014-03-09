# -*- coding: UTF-8 -*-
require 'rspec'
require 'stringio'

REPO_ROOT = File.expand_path('../..', __FILE__)

require File.join(REPO_ROOT, 'lib/rmuh/rpt/log/parsers/base')

describe RMuh::RPT::Log::Parsers::Base do
  let(:text) { StringIO.new("This is a string.\nSo is this!") }
  let(:base) { RMuh::RPT::Log::Parsers::Base.new }

  context 'text' do
    it 'should be a StringIO object' do
      expect(text).to be_an_instance_of StringIO
    end
  end

  context '#new' do
    it 'should take no more than one arg' do
      expect do
        RMuh::RPT::Log::Parsers::Base.new(nil, nil)
      end.to raise_error ArgumentError
    end

    it 'should return an instance of RMuh::RPT::Log::Parsers::Base' do
      expect(base).to be_an_instance_of RMuh::RPT::Log::Parsers::Base
    end
  end

  context '#parse' do
    it 'should take at most 1 argument' do
      expect { base.parse(text, text) }.to raise_error ArgumentError
    end

    it 'should take at least 1 argument' do
      expect { base.parse }.to raise_error ArgumentError
    end

    it 'should raise an error when passed nil' do
      expect { base.parse(nil) }.to raise_error ArgumentError
    end

    it 'should raise an error when passed a String' do
      expect { base.parse('') }.to raise_error ArgumentError
    end

    it 'should raise an error when passed a Fixnum' do
      expect { base.parse(0) }.to raise_error ArgumentError
    end

    it 'should raise an error when passed a Float' do
      expect { base.parse(0.0) }.to raise_error ArgumentError
    end

    it 'should raise an error when passed an Array' do
      expect { base.parse([]) }.to raise_error ArgumentError
    end

    it 'should raise an error when passed a Hash' do
      expect { base.parse({}) }.to raise_error ArgumentError
    end

    it 'should not raise an error when passed a StringIO object' do
      expect { base.parse(StringIO.new) }.to_not raise_error
    end

    it 'should return an Array' do
      expect(base.parse(text)).to be_an_instance_of Array
    end

    it 'should return an the Array with a size of 2' do
      expect(base.parse(text).size).to be 2
    end

    it 'should be an Array of hashes' do
      base.parse(text).each { |p| expect(p).to be_an_instance_of Hash }
    end
  end
end
