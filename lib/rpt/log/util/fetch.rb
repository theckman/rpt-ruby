require 'httparty'
require 'ostruct'

module RPT
  module Log
    module Util
      class Fetch
        include HTTParty
        attr_accessor :cfg

        def initialize(log_url, byte_start = 0, byte_end = nil)
          @cfg = OpenStruct.new({
            log_url: log_url,
            byte_start: byte_start,
            byte_end: byte_end
          })
        end

        def byte_start=(bytes)
          if bytes.is_a?(Integer)
            @cfg.byte_start = bytes
          else
            raise ArgumentError, 'argument 1 must be an integer'
          end
        end

        def byte_end=(bytes)
          if bytes.nil? || bytes.is_a?(Integer)
            @cfg.byte_end = bytes
          else
            raise ArgumentError, 'argument 1 must be nil or an integer'
          end
        end

        def get_size
          self.class.head(@cfg.log_url).headers['content-length'].to_i
        end

        def get_log
          self.class.get(@cfg.log_url, headers: { 'Range' => "bytes=#{@cfg.byte_start}-#{@cfg.byte_end}"}).to_s
        end
      end
    end
  end
end
