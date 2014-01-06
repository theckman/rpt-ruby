require 'rmuh/rpt/log/parsers/default'
require 'tzinfo'

module RMuh
  module RPT
    module Log
      module Parsers
        class UnitedOperations < RMuh::RPT::Log::Parsers::Default
          SERVER_TZ = TZInfo::Timezone.get('America/Los_Angeles')
          DTR = '(?<year>\d+)/(?<month>\d+)/(?<day>\d+),\s+?(?<hour>\d+):(?<min>\d+):(?<sec>\d+)'
          KILLED = %r{\A#{DTR}\s"(?<server_time>[0-9.]+).*?:\s(?<victim>.*?)\s\((?<victim_team>.*?)\)\s.*?by\s(?<offender>.*?)\s\((?<offender_team>.*?)\).*?position: \[(?<victim_position>.*?)\].*?GRID (?<victim_grid>\d+)\).*?position: \[(?<offender_position>.*?)\].*?GRID (?<offender_grid>\d*)\).*?:\s(?<distance>[0-9e.+]+).*?(?:(?<players_nearby>None|\[.*?\])")}
          DIED = %r{\A#{DTR}\s"(?<server_time>[0-9.]+).*?:\s(?<victim>.*?) has died at \[(?<victim_position>.*?)\].*?GRID (?<victim_grid>\d+)\).*?(?:(?<nearby_players>None|\[.*?\])")}
          WOUNDED = %r{\A#{DTR}\s"(?<server_time>[0-9.]+).*?:\s(?<victim>.*?)\s\((?<victim_team>.*?)\)\s.*?by\s(?<offender>.*?)\s\((?<offender_team>.*?)\).*?(?<damage>[0-9.]+)\sdamage}
          ANNOUNCEMENT = %r{\A#{DTR}\s"(?<lead>[#]+?)\s(?<message>.*?)\s(?<tail>[#]+?)"}

          def parse(loglines, convert_to_zulu = true)
            raise ArgumentError, 'argument 1 must be a StringIO object' unless loglines.is_a? StringIO

            cleanlines = loglines.map do |l|
              if ANNOUNCEMENT.match(l)
                line = {:type => :announcement}.merge(match_to_hash(ANNOUNCEMENT.match(l)))
              elsif WOUNDED.match(l)
                line = {:type => :wounded}.merge(match_to_hash(WOUNDED.match(l)))
              elsif KILLED.match(l)
                line = {:type => :killed}.merge(match_to_hash(KILLED.match(l)))
              elsif DIED.match(l)
                line = {:type => :died}.merge(match_to_hash(DIED.match(l)))
              else
                line = nil
              end
              zulu!(line) if convert_to_zulu and !line.nil?
            end.compact
          end

          private

          def match_to_hash(match)
            h = {}
            match.names.each do |m|
              val = nil
              if [:year, :month, :day, :hour, :min, :sec].include?(m.to_sym)
                val = match[m].to_i
              elsif [:server_time, :damage, :distance].include?(m.to_sym)
                val = match[m].to_f
              elsif m.to_sym == :nearby_players
                if match[m] != 'None'
                  val = match[m].gsub('[', '').gsub(']', '').gsub('"', '').split(',')
                end
              else
                val = match[m]
              end
              h.merge!({ m.to_sym => val })
            end
            h
          end

          def zulu!(line)
            t = SERVER_TZ.local_to_utc(Time.new(line[:year], line[:month],
                                                line[:day], line[:hour],
                                                line[:min], line[:sec]))
            [:year, :month, :day, :hour, :min, :sec].each do |k|
              line[k] = t.send(k)
            end
            line
          end
        end
      end
    end
  end
end
