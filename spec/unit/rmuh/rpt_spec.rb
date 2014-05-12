# -*- coding: UTF-8 -*-

describe RMuh do
  context '::VERSION_MAJ' do
    it 'should have a major version that is an integer' do
      expect(RMuh::VERSION_MAJ.is_a?(Integer)).to be_truthy
    end

    it 'should have a major version that is a positive number' do
      expect(RMuh::VERSION_MAJ > -1).to be_truthy
    end
  end

  context '::VERSION_MIN' do
    it 'should have a minor version that is an integer' do
      expect(RMuh::VERSION_MIN.is_a?(Integer)).to be_truthy
    end

    it 'should have a minor version that is a positive integer' do
      expect(RMuh::VERSION_MIN > -1).to be_truthy
    end
  end

  context '::VERSION_REV' do
    it 'should have a revision number that is an integer' do
      expect(RMuh::VERSION_REV.is_a?(Integer)).to be_truthy
    end

    it 'should have a revision number that is a positive integer' do
      expect(RMuh::VERSION_REV > -1).to be_truthy
    end
  end

  context '::VERSION' do
    it 'should have a version that is a string' do
      expect(RMuh::VERSION).to be_an_instance_of String
    end

    it 'should match the following format N.N.N' do
      expect(/\A(?:\d+?\.){2}\d+?/.match(RMuh::VERSION)).to_not be_nil
    end
  end
end
