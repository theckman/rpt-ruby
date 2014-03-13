# -*- coding: UTF-8 -*-
# These are just specs to make sure the example files run with an exit
# code of zero.
#
require 'rspec'
require 'open3'
require 'helpers/spec_helper'

DIR = File.expand_path('../../examples', __FILE__)

describe 'exampple files' do

  context "#{File.join(DIR, 'basic_parsing.rb')}" do
    it 'should run and return a zero exit code' do
      _, _, s = Open3.capture3("ruby #{File.join(DIR, 'basic_parsing.rb')}")
      expect(s.success?).to be_true
    end
  end

  context "#{File.join(DIR, 'basic_serverstats.rb')}" do
    it 'should run and return a zero exit code' do
      _, _, s = Open3.capture3(
        "ruby #{File.join(DIR, 'basic_serverstats.rb')}"
      )
      expect(s.success?).to be_true
    end
  end

  context "#{File.join(DIR, 'serverstats_advanced.rb')}" do
    it 'should run and return a zero exit code' do
      _, _, s = Open3.capture3(
        "ruby #{File.join(DIR, 'serverstats_advanced.rb')}"
      )
      expect(s.success?).to be_true
    end
  end

  context "#{File.join(DIR, 'serverstats_cache.rb')}" do
    it 'should run and return a zero exit code' do
      _, _, s = Open3.capture3(
        "ruby #{File.join(DIR, 'serverstats_cache.rb')}"
      )
      expect(s.success?).to be_true
    end
  end

  context "#{File.join(DIR, 'uolog_parsing.rb')}" do
    it 'should run and return a zero exit code' do
      _, _, s = Open3.capture3(
        "ruby #{File.join(DIR, 'uolog_parsing.rb')}"
      )
      expect(s.success?).to be_true
    end
  end

  context "#{File.join(DIR, 'uorpt_parsing.rb')}" do
    it 'should run and return a zero exit code' do
      _, _, s = Open3.capture3(
        "ruby #{File.join(DIR, 'uorpt_parsing.rb')}"
      )
      expect(s.success?).to be_true
    end
  end
end
