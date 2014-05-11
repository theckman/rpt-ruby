# -*- coding: UTF-8 -*-
require 'rspec'
require_relative 'base'

describe RMuh::ServerStats::Advanced do
  let(:s) do
    RMuh::ServerStats::Advanced.new(host: 'srv1.unitedoperations.net')
  end

  it_should_behave_like 'RMuh::ServerStats::Base'

  context '::method_missing' do
    it 'should not raise an error when given a valid key' do
      expect { s.gamever }.to_not raise_error
    end

    it 'should raise an error when given an invalid key' do
      expect { s.kjsnfsfidnfjsnfisun }.to raise_error NoMethodError
    end

    it 'should return a String when gamever is requested' do
      expect(s.gamever).to be_an_instance_of String
    end
  end
end
