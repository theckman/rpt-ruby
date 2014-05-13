# -*- coding: UTF-8 -*-
require 'spec_helper'

describe RMuh::RPT::Log::Formatters::Base do
  let(:base) { RMuh::RPT::Log::Formatters::Base }

  describe '.format' do
    context 'when given more than one arg' do
      it 'should raise ArgumentError' do
        expect do
          base.format(nil, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when given less than one arg' do
      it 'should raise ArgumentError' do
        expect do
          base.format
        end.to raise_error ArgumentError
      end
    end

    context 'when provided a log event' do
      let(:event) { { type: :log, message: 'ohai' } }

      subject { base.format(event) }

      it { should be_an_instance_of String }

      it { should eql 'ohai' }
    end

    context 'when provided a non-log event' do
      let(:event) { { type: :notlog, message: 'nohai' } }

      subject { base.format(event) }

      it { should be_nil }
    end
  end
end
