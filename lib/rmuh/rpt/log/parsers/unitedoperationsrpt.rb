require 'rmuh/rpt/log/parsers/base'
require 'rmuh/rpt/log/util/unitedoperations'
require 'rmuh/rpt/log/util/unitedoperationsrpt'
require 'digest'
require 'tzinfo'

module RMuh
  module RPT
    module Log
      module Parsers
        class UnitedOperationsRPT < RMuh::RPT::Log::Parsers::Base
          include RMuh::RPT::Log::Util::UnitedOperations
          include RMuh::RPT::Log::Util::UnitedOperationsRPT # Regexp Constants

          def initialize(opts = {})

            if !opts[:to_zulu].nil? && ![TrueClass, FalseClass].include?(opts[:to_zulu].class)
              raise ArgumentError,
                    ':to_zulu must be a boolean value (true|false)'
            end

            if !opts[:timezone].nil? && opts[:timezone].class != TZInfo::DataTimezone
              raise ArgumentError,
                    ':tiemzone must be an instance of TZInfo::DataTimezone'
            end

            @to_zulu = opts[:to_zulu].nil? ? true : opts[:to_zulu]
            @timezone = opts[:timezone].nil? ? UO_TZ : opts[:timezone]
          end

          def parse(loglines)
            if !loglines.is_a?(StringIO)
              raise ArgumentError, 'argument 1 must be a StringIO object'
            end

            cleanlines = loglines.map do |l|
              if ANNOUNCEMENT.match(l)
                # $~ == $LAST_MATCH_INFO (last Regexp MatchData)
                line = {:type => :announcement}.merge(m_to_h($~))
              elsif WOUNDED.match(l)
                line = {:type => :wounded}.merge(m_to_h($~))
              elsif KILLED.match(l)
                line = {:type => :killed}.merge(m_to_h($~))
              elsif DIED.match(l)
                line = {:type => :died}.merge(m_to_h($~))
              else
                line = nil
              end

              zulu!(line, @timezone) if @to_zulu and !line.nil?
              add_guid!(line) unless line.nil?
            end.compact
          end
        end
      end
    end
  end
end
