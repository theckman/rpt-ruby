require 'tzinfo'
require 'digest'

module RMuh
  module RPT
    module Log
      module Util
        # Something
        #
        module UnitedOperations
          UO_TZ ||= TZInfo::Timezone.get('America/Los_Angeles')

          def m_to_h(match)
            __check_match_arg(match)
            h = {}
            match.names.each do |m|
              h.merge!(m.to_sym => __line_modifiers(match, m))
            end
            h
          end

          def __check_match_arg(match)
            fail(
              ArgumentError,
              'argument 1 must be of type MatchData'
            ) unless match.class == MatchData
          end

          def __line_modifiers(match, match_name)
            m = match_name
            if [:year, :month, :day, :hour, :min, :sec].include?(m.to_sym)
              return match[m].to_i
            elsif [:server_time, :damage, :distance, :channel, :nearby_players]
              .include?(m.to_sym)
              return __modifiers(match, m)
            else
              return match[m]
            end
          end

          def __modifiers(match, match_name)
            m = match_name
            if [:server_time, :damage, :distance].include?(m.to_sym)
              return match[m].to_f
            elsif m.to_sym == :channel
              return match[m].downcase
            elsif m.to_sym == :nearby_players
              return __parse_nearby_players(match, m)
            end
          end

          def __parse_nearby_players(match, match_name)
            m = match_name
            if match[m] != 'None'
              val = match[m].gsub('[', '').gsub(']', '').gsub('"', '')
              return val.split(',')
            else
              return []
            end
          end

          def zulu!(line, timezone)
            t = timezone.local_to_utc(Time.new(line[:year], line[:month],
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
            data = __guid_data_base(line)
            data << __guid_data_one(line)
            data << __guid_data_two(line)
            line[:event_guid] = Digest::SHA1.hexdigest data
            line
          end

          def __guid_data_base(line)
            if line[:iso8601].nil?
              return "#{line[:year]}#{line[:month]}#{line[:day]}" \
                     "#{line[:hour]}#{line[:min]}#{line[:sec]}" \
                     "#{line[:type].to_s}"
            else
              return "#{line[:iso8601]}#{line[:type].to_s}"
            end
          end

          def __guid_data_one(line)
            data = ''
            data << line[:message] unless line[:message].nil?
            data << line[:victim] unless line[:victim].nil?
            data << line[:offender] unless line[:offender].nil?
            data << line[:server_time].to_s unless line[:server_time].nil?
            data << line[:damage].to_s unless line[:damage].nil?
            data
          end

          def __guid_data_two(line)
            data = ''
            data << line[:distance].to_s unless line[:distance].nil?
            data << line[:player] unless line[:player].nil?
            data << line[:player_beguid] unless line[:player_beguid].nil?
            data << line[:channel] unless line[:channel].nil?
            data
          end

          def validate_to_zulu(opts)
            if !opts[:to_zulu].nil? &&
               ![TrueClass, FalseClass].include?(opts[:to_zulu].class)
              fail ArgumentError,
                   ':to_zulu must be a boolean value (true|false)'
            end
          end

          def validate_timezone(opts)
            if !opts[:timezone].nil? &&
               opts[:timezone].class != TZInfo::DataTimezone
              fail ArgumentError,
                   ':tiemzone must be an instance of TZInfo::DataTimezone'
            end
          end
        end
      end
    end
  end
end
