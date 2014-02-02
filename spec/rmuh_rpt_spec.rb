require 'rspec'
require File.join(File.expand_path('../..', __FILE__), 'lib/rmuh/rpt')

describe RMuh::RPT do
  context RMuh::RPT::V_MAJ do
    it "should have a major version that is an integer" do
      expect( RMuh::RPT::V_MAJ.is_a?(Integer) ).to be_true
    end

    it "should have a major version that is a positive number" do
      expect( RMuh::RPT::V_MAJ > -1).to be_true
    end
  end

  context RMuh::RPT::V_MIN do
    it "should have a minor version that is an integer" do
      expect( RMuh::RPT::V_MIN.is_a?(Integer) ).to be_true
    end

    it "should have a minor version that is a positive integer" do
      expect( RMuh::RPT::V_MIN > -1 ).to be_true
    end
  end

  context RMuh::RPT::V_REV do
    it "should have a revision number that is an integer" do
      expect( RMuh::RPT::V_REV.is_a?(Integer) ).to be_true
    end

    it "should have a revision number that is a positive integer" do
      expect( RMuh::RPT::V_REV > -1 ).to be_true
    end
  end

  context RMuh::RPT::VERSION do
    it "should have a version that is a string" do
      RMuh::RPT::VERSION.should be_an_instance_of String
    end

    it "should match the following format N.N.N" do
      /\A(?:\d+?\.){2}\d+?/.match(RMuh::RPT::VERSION).should_not be_nil
    end
  end
end