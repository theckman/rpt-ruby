# -*- coding: UTF-8 -*-

require 'gamespy_query'

module RMuh
  # This is the namespace for the Gamespy Query Server Statistics.
  # It has no methods.
  #
  module ServerStats
    # This is the Base server stats class. It wraps GamespyQuery::Socket and
    # adds a simpler interface for the usage of querying the server.
    #
    # The required parameter within the Hash is ':host'. Optional params are:
    # port and cache
    #
    # * port: the GamespyQuery port of the server (usually game port)
    # * cache: whether the data will cache on request, or pull new data each
    #          stats request
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
        opts[:auto_cache] = true unless opts.key?(:auto_cache)
        nil
      end

      def opts_to_instance(opts)
        opts.each { |k, v| instance_variable_set(:"@#{k}", v) }
      end

      def remote_stats
        if @cache
          update_cache if @serverstats.nil? && @auto_cache
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
