# -*- coding: UTF-8 -*-

require 'rspec'
require 'gamespy_query'
require 'helpers/spec_helper'
require File.join(repo_root, 'lib/rmuh/serverstats/base')

describe RMuh::ServerStats::Base do
  context '::DEFAULT_PORT' do
    let(:port) { RMuh::ServerStats::Base::DEFAULT_PORT }

    it 'should be an instance of Fixnum' do
      expect(port).to be_an_instance_of Fixnum
    end

    it 'should be the default ArmA 2 port' do
      expect(port).to eql 2_302
    end
  end

  context '::validate_opts' do
    let(:srv_hash) { { host: '127.0.0.1' } }

    it 'should take no more than one arg' do
      expect do
        RMuh::ServerStats::Base.validate_opts(nil, nil)
      end.to raise_error ArgumentError
    end

    it 'should take no less than one arg' do
      expect do
        RMuh::ServerStats::Base.validate_opts
      end.to raise_error ArgumentError
    end

    it 'should fail if arg 1 does not contain host' do
      expect do
        RMuh::ServerStats::Base.validate_opts({})
      end.to raise_error ArgumentError
    end

    it 'should set the default port if not provided' do
      h = srv_hash.dup
      RMuh::ServerStats::Base.validate_opts(h)
      expect(h.key?(:port)).to be_true
      expect(h[:port]).to eql RMuh::ServerStats::Base::DEFAULT_PORT
    end

    it 'should set the auto_cache key to true if not provided' do
      h = srv_hash.dup
      RMuh::ServerStats::Base.validate_opts(h)
      expect(h.key?(:auto_cache)).to be_true
      expect(h[:auto_cache]).to be_true
    end

    it 'should return nil' do
      x = RMuh::ServerStats::Base.validate_opts(host: '127.0.0.1')
      expect(x).to be_nil
    end
  end

  context '#opts_to_instance' do
    let(:b) { RMuh::ServerStats::Base.new(host: '127.0.0.1') }

    it 'should take no more than one arg' do
      expect do
        b.send(:opts_to_instance, nil, nil)
      end.to raise_error ArgumentError
    end

    it 'should take no less than one arg' do
      expect do
        b.send(:opts_to_instance)
      end.to raise_error ArgumentError
    end

    it 'should convert each key to an instance variable' do
      h = { one: 1, two: '2', three: :three }
      expect(b.instance_variable_get(:@one)).to be_nil
      expect(b.instance_variable_get(:@two)).to be_nil
      expect(b.instance_variable_get(:@three)).to be_nil
      b.send(:opts_to_instance, h)
      expect(b.instance_variable_get(:@one)).to eql h[:one]
      expect(b.instance_variable_get(:@two)).to eql h[:two]
      expect(b.instance_variable_get(:@three)).to eql h[:three]
    end
  end

  context '::new' do
    it 'should take no more than one arg' do
      expect do
        RMuh::ServerStats::Base.new(nil, nil)
      end.to raise_error ArgumentError
    end

    it 'should return an instance of itself if arg 1 is a Hash' do
      s = RMuh::ServerStats::Base.new(host: '127.0.0.1')
      expect(s).to be_an_instance_of RMuh::ServerStats::Base
    end

    it 'should require the host attribute' do
      expect do
        RMuh::ServerStats::Base.new({})
      end.to raise_error ArgumentError
    end

    it 'should set an instance variable for each thing in Hash' do
      h = { host: '1.2.3.4', port: 2_303, cache: false }
      s = RMuh::ServerStats::Base.new(h)
      expect(s.instance_variable_get(:@host)).to eql h[:host]
      expect(s.instance_variable_get(:@port)).to eql h[:port]
      expect(s.instance_variable_get(:@cache)).to eql h[:cache]
    end

    it 'should create an instance of GamespyQuery::Socket' do
      s = RMuh::ServerStats::Base.new(host: '127.0.0.1')
      x = s.instance_variable_get(:@gsq)
      expect(x).to be_an_instance_of GamespyQuery::Socket
    end

    it 'should specify default values for @port and @cache' do
      s = RMuh::ServerStats::Base.new(host: '127.0.0.1')
      expect(s.instance_variable_get(:@cache)).to be true
      expect(s.instance_variable_get(:@port)).to eql 2_302
    end
  end

  context '#sync' do
    before do
      GamespyQuery::Socket.any_instance.stub(:sync).and_return(one: 1)
    end
    let(:b) { RMuh::ServerStats::Base.new(host: '127.0.0.1') }

    it 'should take no args' do
      expect { b.send(:sync, nil) }.to raise_error ArgumentError
    end

    it 'should return a Hash' do
      expect(b.send(:sync)).to be_an_instance_of Hash
    end
  end

  context '#remote_stats' do
    let(:b) { RMuh::ServerStats::Base.new(host: '127.0.0.1') }

    it 'should take no args' do
      expect { b.send(:remote_stats, nil) }.to raise_error ArgumentError
    end

    it 'should return the content of @servicestats if cache == true' do
      b.instance_variable_set(:@serverstats, one: 'two')
      expect(b.send(:remote_stats)).to eql(one: 'two')
    end

    it 'should return the return value from the #sync method if cache true' do
      n = RMuh::ServerStats::Base.new(host: '127.0.0.1', cache: false)
      n.stub(:sync).and_return(one: 'two')
      expect(n.send(:remote_stats)).to eql(one: 'two')
    end
  end

  context '#update_cache' do
    before(:each) do
      @b = RMuh::ServerStats::Base.new(host: '127.0.0.1')
      @bf = RMuh::ServerStats::Base.new(host: '127.0.0.1', cache: false)
      @b.stub(:sync).and_return(one: 'two')
      @bf.stub(:sync).and_return(one: 'two')
    end

    it 'should take no args' do
      expect { @b.update_cache(nil) }.to raise_error ArgumentError
    end

    it 'should set the contents of @serverstats if caching' do
      @b.update_cache
      expect(@b.instance_variable_get(:@serverstats)).to eql(one: 'two')
    end

    it 'should not set the contents of @serverstats if no caching' do
      @bf.update_cache
      expect(@bf.instance_variable_get(:@serverstats)).to be_nil
    end
  end

  context '#stats' do
    before(:each) do
      @b = RMuh::ServerStats::Base.new(host: '127.0.0.1')
      @bf = RMuh::ServerStats::Base.new(host: '127.0.0.1', cache: false)
      @b.stub(:sync).and_return(one: 'two')
      @bf.stub(:sync).and_return(one: 'two')
      @b.update_cache
    end

    it 'should take no args' do
      expect { @b.stats(nil) }.to raise_error ArgumentError
    end

    it 'should return the contents of @serverstats if caching enabled' do
      expect(@b.stats).to eql @b.instance_variable_get(:@serverstats)
    end

    it 'should return the contents of sync if caching is disabled' do
      expect(@bf.stats).to eql(one: 'two')
    end
  end
end
