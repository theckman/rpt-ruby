# -*- coding: UTF-8 -*-
require 'stringio'
require 'English'
require 'tzinfo'
require 'rmuh/rpt/log/parsers/base'
require 'rmuh/rpt/log/util/unitedoperations'
require 'rmuh/rpt/log/util/unitedoperationsrpt'

module RMuh
  module RPT
    module Log
      module Parsers
        # This is the UnitedOperations parser class. This separates the
        # UnitedOperations log lines in to their respective Hashes
        #
        # This can be used to rebuild the log file, from metadata alone.
        #
        # It extends RMuh::RPT::Log::Parsers::Base
        #
        class UnitedOperationsRPT < RMuh::RPT::Log::Parsers::Base
          include RMuh::RPT::Log::Util::UnitedOperations
          extend RMuh::RPT::Log::Util::UnitedOperations
          include RMuh::RPT::Log::Util::UnitedOperationsRPT # Regexp Constants

          # This is used to validate the options passed in to new()
          # Will throw ArgumentError if things aren't right.
          def self.validate_opts(opts)
            fail ArgumentError,
                 'argument 1 should be a Hash' unless opts.class == Hash
            validate_bool_opt(opts, :to_zulu)
            validate_timezone(opts)
          end

          # This is the initializer for the whole object. There are two
          # valid options for this class:
          # :to_zulu -- convert the timestamp to zulu and add iso8601 and dtg
          #             timestamp -- this defaults to true
          # :timezone -- specifies the server's timezone from the tz database
          #              this defaults to the UO timezone
          # --
          # TODO: Convert this to use an auto hash to instance variable
          # ++
          def initialize(opts = {})
            self.class.validate_opts(opts)

            @to_zulu = opts[:to_zulu].nil? ? true : opts[:to_zulu]
            @timezone = opts[:timezone].nil? ? UO_TZ : opts[:timezone]
          end

          # Parse the StringIO object which is the lines from the log.
          # This expects arg 1 to be a StringIO object, otherwise it will
          # throw an ArgumentError exception
          def parse(loglines)
            unless loglines.is_a?(StringIO)
              fail ArgumentError, 'argument 1 must be a StringIO object'
            end

            loglines.map do |l|
              line = regex_match(l)
              puts line
              zulu!(line, @timezone) if @to_zulu && line
              add_guid!(line) unless line.nil?
              line
            end.compact
          end

          private

          def regex_match(l)
            if ANNOUNCEMENT.match(l)
              line = { type: :announcement }.merge(m_to_h($LAST_MATCH_INFO))
            elsif WOUNDED.match(l)
              line = { type: :wounded }.merge(m_to_h($LAST_MATCH_INFO))
            elsif KILLED.match(l)
              line = { type: :killed }.merge(m_to_h($LAST_MATCH_INFO))
            elsif DIED.match(l)
              line = { type: :died }.merge(m_to_h($LAST_MATCH_INFO))
            end
            (defined?(line)) ? line : nil
          end
        end
      end
    end
  end
end
