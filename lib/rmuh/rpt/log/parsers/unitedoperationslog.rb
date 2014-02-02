require 'tzinfo'
require 'stringio'

require 'rmuh/rpt/log/util/unitedoperations'
require 'rmuh/rpt/log/util/unitedoperationslog'
require 'ap'

module RMuh
  module RPT
    module Log
      module Parsers
        class UnitedOperationsLog < RMuh::RPT::Log::Parsers::Base
          include RMuh::RPT::Log::Util::UnitedOperations
          include RMuh::RPT::Log::Util::UnitedOperationsLog # Regexp Constants

          def initialize(opts ={})
            if !opts[:to_zulu].nil? && ![TrueClass, FalseClass].include?(opts[:to_zulu].class)
              raise ArgumentError,
                    ':to_zulu must be a boolean value (true|false)'
            end

            if !opts[:timezone].nil? && opts[:timezone].class != TZInfo::DataTimezone
              raise ArgumentError,
                    ':tiemzone must be an instance of TZInfo::DataTimezone'
            end

            if !opts[:chat].nil? && ![TrueClass, FalseClass].include?(opts[:chat].class)
              raise ArgumentError,
                    ':chat must be a boolean value (true|false)'
            end

            @incldue_chat = opts[:chat].nil? ? false : opts[:chat]
            @to_zulu = opts[:to_zulu].nil? ? true : opts[:to_zulu]
            @timezone = opts[:timezone].nil? ? UO_TZ : opts[:timezone]
          end

          def parse(loglines)
            if !loglines.is_a?(StringIO)
              raise ArgumentError, 'argument 1 must be a StringIO object'
            end

            loglines.map do |l|
              if GUID.match(l)
                line = {type: :guid}.merge(m_to_h($~))
              elsif @include_chat && CHAT.match(l)
                line = {type: :chat}.merge(m_to_h($~))
              else
                line = nil
              end

              when_am_i!(line) unless line.nil?
            end.compact
          end

          private

          def when_am_i!(line)
            case line[:hour]
            when 4..23
              if Time.now.hour.between?(4, 23)
                t = @timezone.now
              else
                t = @timezone.now - ONE_DAY
              end
              set_line_date!(line, t)
            when 0..3
              set_line_date!(line)
            end
            line
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
