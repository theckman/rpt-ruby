require 'stringio'
require_relative '../lib/rmuh/rpt/log/parsers/default'

describe RMuh::RPT::Log::Parsers::Default do
  let(:text) { StringIO.new("This is a string.\nSo is this!") }
  let(:default) { RMuh::RPT::Log::Parsers::Default.new }

  context "text" do
    it "should be a StringIO object" do
      text.should be_an_instance_of StringIO
    end
  end

  context "#new" do
    it "should return an instance of RMuh::RPT::Log::Parsers::Default" do
      default.should be_an_instance_of RMuh::RPT::Log::Parsers::Default
    end
  end

  context "#parse" do
    it "should take at most 1 argument" do
      expect { default.parse(text, text) }.to raise_error ArgumentError
    end

    it "should take at least 1 argument" do
      expect { default.parse }.to raise_error ArgumentError
    end

    it "should only accept a StringIO object" do
      expect { default.parse('urmom') }.to raise_error ArgumentError
      expect { default.parse(42) }.to raise_error ArgumentError
    end

    it "should return an Array" do
      expect(default.parse(text)).to be_an_instance_of Array
    end

    it "the Array size should be 2" do
      expect(default.parse(text).size).to be 2
    end

    it "should be an Array of hashes" do
      default.parse(text).each { |p| p.should be_an_instance_of Hash }
    end
  end
end
