# -*- coding: UTF-8 -*-
require 'English'
require 'tzinfo'
require 'stringio'
require 'rmuh/rpt/log/parsers/base'
require 'rmuh/rpt/log/util/unitedoperations'
require 'rmuh/rpt/log/util/unitedoperationslog'

module RMuh
  module RPT
    module Log
      module Parsers
        # This is the UnitedOperations Log parser class. It separates the log
        # in to an array of Hashes, one for each log line.
        #
        # This can be used to rebuild the log file, from metadata alone.
        #
        # It extends RMuh::RPT::Log::Parsers::Base
        #
        class UnitedOperationsLog < RMuh::RPT::Log::Parsers::Base
          include RMuh::RPT::Log::Util::UnitedOperations
          extend RMuh::RPT::Log::Util::UnitedOperations
          include RMuh::RPT::Log::Util::UnitedOperationsLog # Regexp Constants
          extend RMuh::RPT::Log::Util::UnitedOperationsLog

          # Validate the options that are passed in as arg 1 to the new()
          # function
          #
          # This raises ArgumentError if something doesn't pass
          #
          def self.validate_opts(opts)
            fail(
              ArgumentError, 'arg 1 should be an instance of Hash'
            ) unless opts.is_a?(Hash)
            validate_bool_opt(opts, :to_zulu)
            validate_timezone(opts)
            validate_bool_opt(opts, :chat)
          end

          # This builds the object. There are three optional args for the Hash:
          # * :chat -- should chat lines be included?
          # * :to_zulu -- convert timestamp to zulu
          # * :timezone -- specify the server timezone
          # --
          # TODO: Make this use an auto hash to instance variable function
          # ++
          def initialize(opts = {})
            self.class.validate_opts(opts)
            @include_chat = opts[:chat].nil? ? false : opts[:chat]
            @to_zulu = opts[:to_zulu].nil? ? true : opts[:to_zulu]
            @timezone = opts[:timezone].nil? ? UO_TZ : opts[:timezone]
          end

          def parse(loglines)
            unless loglines.is_a?(StringIO)
              fail ArgumentError, 'arg 1 must be a StringIO object'
            end
            regex_matches(loglines)
          end

          private

          def regex_matches(loglines)
            loglines.map do |l|
              line = nil
              if GUID.match(l)
                line = { type: :beguid }.merge(m_to_h($LAST_MATCH_INFO))
              elsif @include_chat && CHAT.match(l)
                line = { type: :chat }.merge(m_to_h($LAST_MATCH_INFO))
              end
              line_modifiers(line) unless line.nil?
            end.compact
          end

          def line_modifiers(line)
            when_am_i!(line)
            zulu!(line, @timezone)
            add_guid!(line)
            line
          end

          def when_am_i!(line)
            case line[:hour]
            when 4..23
              t = date_of_line_based_on_now
              set_line_date!(line, t)
            when 0..3
              set_line_date!(line)
            end
            line
          end

          def date_of_line_based_on_now(time = Time.now)
            if time.hour.between?(4, 23)
              @timezone.now
            else
              @timezone.now - ONE_DAY
            end
          end

          def set_line_date!(line, time = @timezone.now)
            line[:year] = time.year
            line[:month] = time.month
            line[:day] = time.day
            line
          end
        end
      end
    end
  end
end
