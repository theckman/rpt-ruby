require 'rmuh/rpt/log/parsers/base'
require 'rmuh/rpt/log/utils'
require 'digest'
require 'tzinfo'

module RMuh
  module RPT
    module Log
      module Parsers
        class UnitedOperationsRPT < RMuh::RPT::Log::Parsers::Base
          include RMuh::RPT::Log::Utils

          DTR = '(?<year>\d+)/(?<month>\d+)/(?<day>\d+),\s+?(?<hour>\d+):(?<min>\d+):(?<sec>\d+)'
          KILLED = %r{^#{DTR}\s"(?<server_time>[0-9.]+).*?:\s(?<victim>.*?)\s\((?<victim_team>.*?)\)\s.*?by\s(?<offender>.*?)\s\((?<offender_team>.*?)\).*?position: \[(?<victim_position>.*?)\].*?GRID (?<victim_grid>\d+)\).*?position: \[(?<offender_position>.*?)\].*?GRID (?<offender_grid>\d*)\).*?:\s(?<distance>[0-9e.+]+).*?(?:(?<nearby_players>None|\[.*?\])")}
          DIED = %r{^#{DTR}\s"(?<server_time>[0-9.]+).*?:\s(?<victim>.*?) has died at \[(?<victim_position>.*?)\].*?GRID (?<victim_grid>\d+)\).*?(?:(?<nearby_players>None|\[.*?\])")}
          WOUNDED = %r{^#{DTR}\s"(?<server_time>[0-9.]+).*?:\s(?<victim>.*?)\s\((?<victim_team>.*?)\)\s.*?by\s(?<offender>.*?)\s\((?<offender_team>.*?)\).*?(?<damage>[0-9.]+)\sdamage}
          ANNOUNCEMENT = %r{^#{DTR}\s"(?<head>[#]+?)\s(?<message>.*?)\s(?<tail>[#]+?)"}

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
            @timezone = [:timezone].nil? ? TZInfo::Timezone.get('America/Los_Angeles') : opts[:timezone]
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
