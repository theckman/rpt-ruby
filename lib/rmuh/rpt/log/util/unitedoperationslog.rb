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
          TIME_SHORT ||= '^\s*?(?<hour>\d+?):(?<min>\d+?):(?<sec>\d+)\s'
          TIME ||= "#{TIME_SHORT}BattlEye\sServer:\s"
          GUID ||= Regexp.new(
            "#{TIME}.*Verified\\sGUID\\s\\((?<player_beguid>.*?)\\).*#" \
            '(?<player_num>\\d+?)' \
            '\s(?<player>.+)$'
          )
          CHAT ||= Regexp.new(
            "#{TIME}\\((?<channel>Group|Global|Side|Vehicle|Command|Unknown)" \
            '\)\s+?(?<player>.+?):\s(?<message>.*)$'
          )
          JOINED ||= Regexp.new(
            "#{TIME}Player\s\#(?<player_num>\\d+)\s(?<player>.*?)\s" \
            '\\((?<net>.*?)\\)\sconnected'
          )
          LEFT ||= Regexp.new(
            "#{TIME_SHORT}Player\s(?<player>.*?)\sdisconnected\."
          )
        end
      end
    end
  end
end
