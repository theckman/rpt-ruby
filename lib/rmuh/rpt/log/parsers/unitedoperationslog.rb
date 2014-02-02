require 'tzinfo'
require 'rmuh/rpt/log/utils'
require 'ap'

module RMuh
  module RPT
    module Log
      module Parsers
        class UnitedOperationsLog < RMuh::RPT::Log::Parsers::Base
          include RMuh::RPT::Log::Utils

          TIME = '^\s*?(?<hour>\d+?):(?<min>\d+?):(?<sec>\d+)\sBattlEye\sServer:\s'
          GUID = %r{#{TIME}.*Verified\sGUID\s\((?<player_guid>.*?)\).*#\d+?\s(?<player>.+)$}
          CHAT = %r{#{TIME}\((?<channel>Group|Global|Side|Vehicle|Command|Unknown)\)\s+?(?<player>.+?):\s(?<msg>.*)$}

          def initialize(
            to_zulu = true,
            timezone = TZInfo::Timezone.get('America/Los_Angeles')
          )
            if to_zulu.class != TrueClass && to_zulu.class != FalseClass
              raise ArgumentError,
                    'arg 1 must be a boolean value (true|false)'
            end

            if timezone.class != TZInfo::DataTimezone
              raise ArgumentError,
                    'arg 1 must be an instance of TZInfo::DataTimezone'
            end

            @to_zulu = to_zulu
            @timezone = timezone
          end

          def parse(loglines)
            loglines.map do |l|
              if GUID.match(l)
                line = {type: :guid}.merge(m_to_h($~))
              elsif CHAT.match(l)
                line = {type: :chat}.merge(m_to_h($~))
              else
                line = nil
              end
            end.compact
          end
        end
      end
    end
  end
end
