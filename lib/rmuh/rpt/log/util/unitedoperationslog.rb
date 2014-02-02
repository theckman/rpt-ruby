module RMuh
  module RPT
    module Log
      module Util
        module UnitedOperationsLog

          ONE_DAY ||= 86400
          TIME ||= '^\s*?(?<hour>\d+?):(?<min>\d+?):(?<sec>\d+)\sBattlEye\sServer:\s'
          GUID ||= %r{#{TIME}.*Verified\sGUID\s\((?<player_guid>.*?)\).*#\d+?\s(?<player>.+)$}
          CHAT ||= %r{#{TIME}\((?<channel>Group|Global|Side|Vehicle|Command|Unknown)\)\s+?(?<player>.+?):\s(?<msg>.*)$}

        end
      end
    end
  end
end