module RMuh
  module RPT
    module Log
      module Util
        module UnitedOperationsLog
          ONE_DAY ||= 86400
          TIME ||= '^\s*?(?<hour>\d+?):(?<min>\d+?):(?<sec>\d+)\sBattlEye\sServer:\s'
          GUID ||= %r{#{TIME}.*Verified\sGUID\s\((?<player_beguid>.*?)\).*#\d+?\s(?<player>.+)$}
          CHAT ||= %r{#{TIME}\((?<channel>Group|Global|Side|Vehicle|Command|Unknown)\)\s+?(?<player>.+?):\s(?<message>.*)$}

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