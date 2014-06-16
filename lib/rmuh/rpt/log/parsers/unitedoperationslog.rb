# -*- coding: UTF-8 -*-
require 'English'
require 'tzinfo'
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
            @include_chat = opts.fetch(:chat, false)
            @to_zulu = opts.fetch(:to_zulu, true)
            @timezone = opts.fetch(:timezone, UO_TZ)
          end

          def parse(loglines)
            unless loglines.is_a?(Array)
              fail ArgumentError, 'arg 1 must be an Array object'
            end
            regex_matches(loglines)
          end

          private

          def regex_matches(loglines)
            regexes = [[LEFT, :disconnect], [CHAT, :chat], [JOINED, :connect],
                       [GUID, :beguid]]
            loglines.map do |l|
              line = nil
              regexes.each do |reg|
                next if !reg[0].match(l) || (reg[1] == :chat && !@include_chat)
                line = { type: reg[1] }.merge(m_to_h($LAST_MATCH_INFO))
              end
              line_modifiers(line) unless line.nil?
            end.compact
          end

          def line_modifiers(line)
            when_am_i!(line)
            zulu!(line, @timezone)
            add_guid!(line)
            strip_port!(line) if line[:type] == :connect
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

          def strip_port!(line)
            line[:ipaddr] = line[:net].split(':')[0]
            line.delete(:net)
            line
          end
        end
      end
    end
  end
end
