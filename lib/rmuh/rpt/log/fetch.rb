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
        attr_accessor :cfg

        # New class. Required param (#1) log_url, optional second
        # and third options are byte_start and byte_end
        # --
        # TODO: Make these latter options Hash options
        # ++
        def initialize(log_url, byte_start = 0, byte_end = nil)
          @cfg = OpenStruct.new(
            log_url: log_url,
            byte_start: byte_start,
            byte_end: byte_end
          )
        end

        def byte_start=(bytes)
          if bytes.is_a?(Integer)
            @cfg.byte_start = bytes
          else
            fail ArgumentError, 'argument 1 must be an integer'
          end
        end

        def byte_end=(bytes)
          if bytes.nil? || bytes.is_a?(Integer)
            @cfg.byte_end = bytes
          else
            fail ArgumentError, 'argument 1 must be nil or an integer'
          end
        end

        def size
          self.class.head(@cfg.log_url).headers['content-length'].to_i
        end

        def log
          headers = { 'Range' => "bytes=#{@cfg.byte_start}-#{@cfg.byte_end}" }
          response = self.class.get(@cfg.log_url, headers: headers)
          StringIO.new(response.lines.map { |l| dos2unix(l) }.join)
        end

        private

        def dos2unix(line)
          line.gsub("\r\n", "\n")
        end
      end
    end
  end
end
