# -*- coding: UTF-8 -*-
# These are just specs to make sure the example files run with an exit
# code of zero.
#

require 'spec_helper'
require 'open3'

DIR = File.expand_path('../../../examples', __FILE__)
EXAMPLE_FILES = Dir.chdir(DIR) { Dir['*'] }.map { |f| File.expand_path(File.join(DIR, f)) }

describe 'example file' do
  EXAMPLE_FILES.each do |e|
    context File.basename(e) do
      it 'should run and return a zero exit code' do
        _, _, s = Open3.capture3("bundle exec ruby #{e}")
        expect(s.success?).to be_truthy
      end
    end
  end
end
