require 'rmuh/rpt/log/parsers/default'
require 'digest'
require 'tzinfo'

module RMuh
  module RPT
    module Log
      module Parsers
        class UnitedOperations < RMuh::RPT::Log::Parsers::Default
          DTR = '(?<year>\d+)/(?<month>\d+)/(?<day>\d+),\s+?(?<hour>\d+):(?<min>\d+):(?<sec>\d+)'
          KILLED = %r{^#{DTR}\s"(?<server_time>[0-9.]+).*?:\s(?<victim>.*?)\s\((?<victim_team>.*?)\)\s.*?by\s(?<offender>.*?)\s\((?<offender_team>.*?)\).*?position: \[(?<victim_position>.*?)\].*?GRID (?<victim_grid>\d+)\).*?position: \[(?<offender_position>.*?)\].*?GRID (?<offender_grid>\d*)\).*?:\s(?<distance>[0-9e.+]+).*?(?:(?<nearby_players>None|\[.*?\])")}
          DIED = %r{^#{DTR}\s"(?<server_time>[0-9.]+).*?:\s(?<victim>.*?) has died at \[(?<victim_position>.*?)\].*?GRID (?<victim_grid>\d+)\).*?(?:(?<nearby_players>None|\[.*?\])")}
          WOUNDED = %r{^#{DTR}\s"(?<server_time>[0-9.]+).*?:\s(?<victim>.*?)\s\((?<victim_team>.*?)\)\s.*?by\s(?<offender>.*?)\s\((?<offender_team>.*?)\).*?(?<damage>[0-9.]+)\sdamage}
          ANNOUNCEMENT = %r{^#{DTR}\s"(?<head>[#]+?)\s(?<message>.*?)\s(?<tail>[#]+?)"}

          def initialize(
            to_zulu = true,
            timezone = TZInfo::Timezone.get('America/Los_Angeles')
          )
            if to_zulu.class != TrueClass && to_zulu.class != FalseClass
              raise ArgumentError, 'arg 1 must be a boolean value (true|false)'
            end

            if timezone.class != TZInfo::DataTimezone
              raise ArgumentError, 'arg 1 must be an instance of TZInfo::DataTimezone'
            end

            @to_zulu = to_zulu
            @timezone = timezone
          end
          def parse(loglines)
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

              zulu!(line) if @to_zulu and !line.nil?
              add_guid!(line) unless line.nil?
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
                  val = match[m].gsub('[', '').gsub(']', '').gsub('"', '')
                  val = val.split(',')
                end
              else
                val = match[m]
              end
              h.merge!({ m.to_sym => val })
            end
            h
          end

          def zulu!(line)
            t = @timezone.local_to_utc(Time.new(line[:year], line[:month],
                                                line[:day], line[:hour],
                                                line[:min], line[:sec]))

            [:year, :month, :day, :hour, :min, :sec].each do |k|
              line[k] = t.send(k)
            end

            line[:iso8601] = t.iso8601
            line[:dtg] = t.strftime('%d%H%MZ %^b %y')

            line
          end

          def add_guid!(line)
            if line[:iso8601].nil?
              data = "#{line[:year]}#{line[:month]}#{line[:day]}" \
                     "#{line[:hour]}#{line[:min]}#{line[:sec]}" \
                     "#{line[:type].to_s}"
            else
              data = "#{line[:iso8601]}#{line[:type].to_s}"
            end
            data << line[:message] unless line[:message].nil?
            data << line[:victim] unless line[:victim].nil?
            data << line[:offender] unless line[:offender].nil?
            data << line[:server_time].to_s unless line[:server_time].nil?
            data << line[:damage].to_s unless line[:damage].nil?
            data << line[:distance].to_s unless line[:distance].nil?

            line[:event_guid] = Digest::SHA1.hexdigest data
            line
          end
        end
      end
    end
  end
end
