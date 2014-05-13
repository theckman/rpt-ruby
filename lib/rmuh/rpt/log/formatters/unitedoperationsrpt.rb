# -*- coding: UTF-8 -*-
#
# By the end you will be sick of the letter 'e', I sure am...
#
require_relative 'base'

module RMuh
  module RPT
    module Log
      module Formatters
        # Formatter for the UnitedOperations RPT file
        class UnitedOperationsRPT < RMuh::RPT::Log::Formatters::Base
          LEVELS ||= [:full, :ext, :simple]

          class << self
            def format(event, level = :full)
              validate_and_set_level(level)
              case event[:type]
              when :wounded
                format_wounded(event)
              when :killed
                format_killed(event)
              when :died
                format_died(event)
              when :announcement
                format_announcement(event)
              else
                nil
              end
            end

            private

            def validate_and_set_level(level)
              fail(
                ArgumentError,
                "Log level invalid, can be one of #{LEVELS.join(', ')}"
              ) unless LEVELS.include?(level)
              @level = level
            end

            def time(e)
              "#{e[:iso8601]}"
            end

            def server_time(e)
              "#{time(e)} \"#{e[:server_time]} seconds:"
            end

            def nearby_players(e)
              players = e[:nearby_players]
              if players.empty?
                n = 'None'
              else
                p = e[:nearby_players].map { |pl| "'#{pl}'" }.join(',')
                n = "[#{p}]"
              end
              ". Nearby players (100m): #{n}"
            end

            def format_wounded(e)
              l = "#{server_time(e)} #{e[:victim]} (#{e[:victim_team]}) has "
              l += "been wounded by #{e[:offender]} (#{e[:offender_team]})"
              l += format_wounded_ext(e) if [:full, :ext].include?(@level)
              l += "\"\n"
              l
            end

            def format_wounded_ext(e)
              " for #{e[:damage]} damage"
            end

            def format_killed(e)
              l = "#{server_time(e)} #{e[:victim]} (#{e[:victim_team]}) "
              l += "has been killed by #{e[:offender]} (#{e[:offender_team]})"
              l += format_killed_ext(e) if [:ext, :full].include?(@level)
              l += nearby_players(e) if @level == :full
              l += "\"\n"
              l
            end

            def format_killed_ext(e)
              ". #{e[:victim]} pos: [#{e[:victim_position]}] (GRID " \
              "#{e[:victim_grid]}). #{e[:offender]} pos: " \
              "[#{e[:offender_position]}] (GRID #{e[:offender_grid]}). " \
              "Distance between: #{e[:distance]}m"
            end

            def format_died(e)
              l = "#{server_time(e)} #{e[:victim]} has bled out or died of " \
                  'pain'
              l += format_died_ext(e) if [:full, :ext].include?(@level)
              l += nearby_players(e) if @level == :full
              l += "\"\n"
              l
            end

            def format_died_ext(e)
              " at [#{e[:victim_position]}] (GRID #{e[:victim_grid]})"
            end

            def format_announcement(e)
              "#{time(e)} \"#{e[:head]} #{e[:message]} #{e[:tail]}\"\n"
            end
          end
        end
      end
    end
  end
end
