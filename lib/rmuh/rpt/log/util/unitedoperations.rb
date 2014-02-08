require 'tzinfo'
require 'digest'

module RMuh
  module RPT
    module Log
      module Util
        module UnitedOperations

          UO_TZ ||= TZInfo::Timezone.get('America/Los_Angeles')

          def m_to_h(match)
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

          def validate_chat(opts)
            if !opts[:chat].nil? &&
               ![TrueClass, FalseClass].include?(opts[:chat].class)
              fail ArgumentError,
                   ':chat must be a boolean value (true|false)'
            end
          end
        end
      end
    end
  end
end
