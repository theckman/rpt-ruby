# -*- coding; UTF-8 -*-
# These are just specs to make sure the example files run with an exit
# code of zero.
#
require 'rspec'
require 'open3'
require 'helpers/spec_helper'

describe 'exampple files' do
  let(:dir) { File.expand_path('../../examples', __FILE__) }

  context 'basic_parsing' do
    it 'should run and return a zero exit code' do
      _, _, s = Open3.capture3("ruby #{File.join(dir, 'basic_parsing.rb')}")
      expect(s.success?).to be_true
    end
  end
end
