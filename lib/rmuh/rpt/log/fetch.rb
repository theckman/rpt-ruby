# -*- coding: UTF-8 -*-
require 'httparty'
require 'ostruct'

module RMuh
  module RPT
    module Log
      # This is the RPT Log fetcher class. It allows fetching a specific URL,
      # only pulling a specific byte range, as well as getting the size of the
      # external file
      #
      class Fetch
        include HTTParty
        attr_accessor :log_url, :byte_start, :byte_end

        def self.validate_opts(opts)
          if opts.key?(:byte_start) &&
             (!opts[:byte_start].is_a?(Fixnum) || opts[:byte_start] < 0)
            fail(ArgumentError, ':byte_start must be a Fixnum >= 0')
          end
          if opts.key?(:byte_end) &&
             ![Fixnum, NilClass].include?(opts[:byte_end].class)
            fail(ArgumentError, ':byte_end must be nil or Fixnum')
          end
        end

        # New Fetch class. This is used for fetching the ArmA 2 log files
        # Required param (#1): (String) The log file URL
        # Optional param (#2): (Hash):
        # * :byte_start - what byte to start the log file from
        # * :byte_end - the last byte that we want from the log file
        #
        def initialize(log_url, opts = {})
          @log_url = log_url
          @byte_start = opts.fetch(:byte_start, 0)
          @byte_end = opts.fetch(:byte_end, nil)
        end

        def byte_start=(bytes)
          self.class.validate_opts(byte_start: bytes)
          @byte_start = bytes
        end

        def byte_end=(bytes)
          self.class.validate_opts(byte_end: bytes)
          @byte_end = bytes
        end

        def size
          self.class.head(@log_url).headers['content-length'].to_i
        end

        def log
          headers = { 'Range' => "bytes=#{@byte_start}-#{@byte_end}" }
          response = self.class.get(@log_url, headers: headers)
          response.lines.map { |l| dos2unix(l).gsub("\n", '') }
        end

        private

        def dos2unix(line)
          line.gsub("\r\n", "\n")
        end
      end
    end
  end
end
