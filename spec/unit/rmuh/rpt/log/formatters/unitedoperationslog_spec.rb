# -*- coding: UTF-8 -*-
require 'spec_helper'

describe RMuh::RPT::Log::Formatters::UnitedOperationsLog do
  let(:uolog) { RMuh::RPT::Log::Formatters::UnitedOperationsLog }

  describe 'time' do
    context 'when given more than two args' do
      it 'should raise ArgumentError' do
        expect do
          uolog.send(:time, nil, nil, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when given less than one arg' do
      it 'should raise ArgumentError' do
        expect do
          uolog.send(:time)
        end.to raise_error ArgumentError
      end
    end

    context 'when given an event for a message event' do
      let(:event) { { iso8601: '1970-01-01T00:00:00Z' } }

      subject { uolog.send(:time, event, :m) }

      it { should be_an_instance_of String }

      it { should eql '1970-01-01T00:00:00Z Server: ' }
    end

    context 'when given an event for a chat event' do
      let(:event) { { iso8601: '1970-01-01T00:00:00Z' } }

      subject { uolog.send(:time, event, :c) }

      it { should be_an_instance_of String }

      it { should eql '1970-01-01T00:00:00Z Chat: ' }
    end

    context 'when given an event with the event not specified' do
      let(:event) { { iso8601: '1970-01-01T00:00:00Z' } }

      subject { uolog.send(:time, event) }

      it { should be_an_instance_of String }

      it { should eql '1970-01-01T00:00:00Z Server: ' }
    end
  end

  describe '.format_chat' do
    context 'when given more than one arg' do
      it 'should raise ArgumentError' do
        expect do
          uolog.send(:format_chat, nil, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when given less than one arg' do
      it 'should raise ArgumentError' do
        expect do
          uolog.send(:format_chat)
        end.to raise_error ArgumentError
      end
    end

    context 'when given a chat event' do
      let(:event) do
        {
          iso8601: '1970-01-01T00:00:00Z', channel: 'group',
          player: 'Heckman', message: 'Seriously?'
        }
      end

      subject { uolog.send(:format_chat, event) }

      it { should be_an_instance_of String }

      it 'should call .time() with the proper args' do
        expect(uolog).to receive(:time).with(event, :c)
          .and_return('1970-01-01T00:00:00Z Chat: ')
        subject
      end

      it do
        should eql "1970-01-01T00:00:00Z Chat: (group) Heckman: Seriously?\n"
      end
    end
  end

  describe '.format_beguid' do
    context 'when given more than one arg' do
      it 'should raise ArgumentError' do
        expect do
          uolog.send(:format_beguid, nil, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when given less than one arg' do
      it 'should raise ArgumentError' do
        expect do
          uolog.send(:format_beguid)
        end.to raise_error ArgumentError
      end
    end

    context 'when given a beguid event' do
      let(:event) do
        {
          iso8601: 'z', player_beguid: 'x', player: 'y', player_num: 0
        }
      end

      subject { uolog.send(:format_beguid, event) }

      it { should be_an_instance_of String }

      it 'should call .time() with the proper args' do
        expect(uolog).to receive(:time).with(event)
          .and_return('z Server: ')
        subject
      end

      it { should eql "z Server: Verified GUID (x) of player #0 y\n" }
    end
  end

  describe '.format_disconnect' do
    context 'when given more than one arg' do
      it 'should raise ArgumentError' do
        expect do
          uolog.send(:format_disconnect, nil, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when given less than one arg' do
      it 'should raise ArgumentError' do
        expect do
          uolog.send(:format_disconnect)
        end.to raise_error ArgumentError
      end
    end

    context 'when given a beguid event' do
      let(:event) do
        {
          iso8601: 'z', player: 'x'
        }
      end

      subject { uolog.send(:format_disconnect, event) }

      it { should be_an_instance_of String }

      it 'should call .time() with the proper args' do
        expect(uolog).to receive(:time).with(event)
          .and_return('z Server: ')
        subject
      end

      it { should eql "z Server: Player x disconnected\n" }
    end
  end

  describe '.format_connect' do
    context 'when given more than one arg' do
      it 'should raise ArgumentError' do
        expect do
          uolog.send(:format_connect, nil, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when given less than one arg' do
      it 'should raise ArgumentError' do
        expect do
          uolog.send(:format_connect)
        end.to raise_error ArgumentError
      end
    end

    context 'when given a beguid event' do
      let(:event) do
        {
          iso8601: 'z', player: 'x', player_num: 0, ipaddr: '127.0.0.1'
        }
      end

      subject { uolog.send(:format_connect, event) }

      it { should be_an_instance_of String }

      it 'should call .time() with the proper args' do
        expect(uolog).to receive(:time).with(event)
          .and_return('z Server: ')
        subject
      end

      it { should eql "z Server: Player #0 x (127.0.0.1) connected\n" }
    end
  end

  describe '.format' do
    context 'when given more than one arg' do
      it 'should raise ArgumentError' do
        expect do
          uolog.format(nil, nil)
        end.to raise_error ArgumentError
      end
    end

    context 'when given less than one arg' do
      it 'should raise ArgumentError' do
        expect do
          uolog.format
        end.to raise_error ArgumentError
      end
    end

    context 'when given a :connect event' do
      let(:event) { { type: :connect } }
      it 'should call .format_connect' do
        expect(uolog).to receive(:format_connect).with(event)
          .and_return('ohai')
        expect(uolog.format(event)).to eql 'ohai'
      end
    end

    context 'when given a :disconnect event' do
      let(:event) { { type: :disconnect } }
      it 'should call .format_disconnect' do
        expect(uolog).to receive(:format_disconnect).with(event)
          .and_return('ohai2')
        expect(uolog.format(event)).to eql 'ohai2'
      end
    end

    context 'when given a :beguid event' do
      let(:event) { { type: :beguid } }
      it 'should call .format_connect' do
        expect(uolog).to receive(:format_beguid).with(event)
          .and_return('ohai3')
        expect(uolog.format(event)).to eql 'ohai3'
      end
    end

    context 'when given a :chat event' do
      let(:event) { { type: :chat } }
      it 'should call .format_beguid' do
        expect(uolog).to receive(:format_chat).with(event)
          .and_return('ohai4')
        expect(uolog.format(event)).to eql 'ohai4'
      end
    end

    context 'when given an unknown event' do
      let(:event) { { type: :x } }
      it 'should call .format_connect' do
        expect(uolog.format(event)).to be_nil
      end
    end
  end
end
