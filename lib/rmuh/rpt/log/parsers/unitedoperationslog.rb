require 'tzinfo'
require 'stringio'

require 'rmuh/rpt/log/util/unitedoperations'
require 'rmuh/rpt/log/util/unitedoperationslog'

module RMuh
  module RPT
    module Log
      module Parsers
        # TODO: UnitedOperationsLog Class Documentation
        #
        class UnitedOperationsLog < RMuh::RPT::Log::Parsers::Base
          include RMuh::RPT::Log::Util::UnitedOperations
          include RMuh::RPT::Log::Util::UnitedOperationsLog # Regexp Constants

          def initialize(opts = {})
            validate_opts(opts)

            @incldue_chat = opts[:chat].nil? ? false : opts[:chat]
            @to_zulu = opts[:to_zulu].nil? ? true : opts[:to_zulu]
            @timezone = opts[:timezone].nil? ? UO_TZ : opts[:timezone]
          end

          def validate_opts(opts)
            validate_to_zulu(opts)
            validate_timezone(opts)
            validate_chat(opts)
          end

          def parse(loglines)
            unless loglines.is_a?(StringIO)
              fail ArgumentError, 'argument 1 must be a StringIO object'
            end
            regex_matches(loglines)
          end

          private

          def regex_matches(loglines)
            loglines.map do |l|
              line = nil
              if GUID.match(l)
                line = { type: :guid }.merge(m_to_h($LAST_MATCH_INFO))
              elsif @include_chat && CHAT.match(l)
                line = { type: :chat }.merge(m_to_h($LAST_MATCH_INFO))
              end
              when_am_i!(line) unless line.nil?
            end.compact
          end

          def when_am_i!(line)
            case line[:hour]
            when 4..23
              t = date_of_line_base_on_now
              set_line_date!(line, t)
            when 0..3
              set_line_date!(line)
            end
            line
          end

          def date_of_line_based_on_now
            if Time.now.hour.between?(4, 23)
              t = @timezone.now
            else
              t = @timezone.now - ONE_DAY
            end
            t
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
