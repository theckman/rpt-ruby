module RMuh
  module RPT
    module Log
      module Util
        module UnitedOperationsRPT

          DTR ||= '(?<year>\d+)/(?<month>\d+)/(?<day>\d+),\s+?(?<hour>\d+):(?<min>\d+):(?<sec>\d+)'
          KILLED ||= %r{^#{DTR}\s"(?<server_time>[0-9.]+).*?:\s(?<victim>.*?)\s\((?<victim_team>.*?)\)\s.*?by\s(?<offender>.*?)\s\((?<offender_team>.*?)\).*?position: \[(?<victim_position>.*?)\].*?GRID (?<victim_grid>\d+)\).*?position: \[(?<offender_position>.*?)\].*?GRID (?<offender_grid>\d*)\).*?:\s(?<distance>[0-9e.+]+).*?(?:(?<nearby_players>None|\[.*?\])")}
          DIED ||= %r{^#{DTR}\s"(?<server_time>[0-9.]+).*?:\s(?<victim>.*?) has died at \[(?<victim_position>.*?)\].*?GRID (?<victim_grid>\d+)\).*?(?:(?<nearby_players>None|\[.*?\])")}
          WOUNDED ||= %r{^#{DTR}\s"(?<server_time>[0-9.]+).*?:\s(?<victim>.*?)\s\((?<victim_team>.*?)\)\s.*?by\s(?<offender>.*?)\s\((?<offender_team>.*?)\).*?(?<damage>[0-9.]+)\sdamage}
          ANNOUNCEMENT ||= %r{^#{DTR}\s"(?<head>[#]+?)\s(?<message>.*?)\s(?<tail>[#]+?)"}

        end
      end
    end
  end
end