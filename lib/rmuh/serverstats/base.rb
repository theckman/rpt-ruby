# -*- coding: UTF-8 -*-

require 'gamespy_query'

module RMuh
  # TODO: Documentation
  #
  module ServerStats
    # TODO: Documentation
    #
    class Base
      DEFAULT_PORT = 2_302

      def initialize(opts = {})
        fail ArgumentError, 'arg 1 must be a Hash' unless opts.is_a?(Hash)
        self.class.validate_opts(opts)
        opts_to_instance(opts)
        @gsq = GamespyQuery::Socket.new("#{@host}:#{@port}")
      end

      def stats
        remote_stats
      end

      def update_cache
        @serverstats = sync if @cache
      end

      private

      def self.validate_opts(opts)
        fail ArgumentError, ':host is required' unless opts.key?(:host)
        opts[:port] ||= DEFAULT_PORT
        opts[:cache] = true unless opts.key?(:cache)
        nil
      end

      def opts_to_instance(opts)
        opts.each { |k, v| instance_variable_set(:"@#{k}", v) }
      end

      def remote_stats
        if @cache
          @serverstats
        else
          sync
        end
      end

      def sync
        @gsq.sync
      end
    end
  end
end