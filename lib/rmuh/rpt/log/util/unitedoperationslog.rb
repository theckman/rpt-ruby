# -*- coding: UTF-8 -*-
module RMuh
  module RPT
    module Log
      module Util
        # The utility module for the UnitedOperationsLog parser
        # This provides the constants needed for Regex matches
        # as well as the validate_chat function
        #
        module UnitedOperationsLog
          ONE_DAY ||= 86_400
          TIME ||= '^\s*?(?<hour>\d+?):(?<min>\d+?):(?<sec>\d+)\s' \
                   'BattlEye\sServer:\s'
          GUID ||= Regexp.new(
            "#{TIME}.*Verified\\sGUID\\s\\((?<player_beguid>.*?)\\).*#\\d+?" \
            '\s(?<player>.+)$'
          )
          CHAT ||= Regexp.new(
            "#{TIME}\\((?<channel>Group|Global|Side|Vehicle|Command|Unknown)" \
            '\)\s+?(?<player>.+?):\s(?<message>.*)$'
          )
        end
      end
    end
  end
end
