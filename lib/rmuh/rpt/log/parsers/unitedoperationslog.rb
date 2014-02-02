require 'tzinfo'
require 'rmuh/rpt/log/utils'
require 'ap'

module RMuh
  module RPT
    module Log
      module Parsers
        class UnitedOperationsLog < RMuh::RPT::Log::Parsers::Base
          include RMuh::RPT::Log::Utils

          ONE_DAY = 86400

          TIME = '^\s*?(?<hour>\d+?):(?<min>\d+?):(?<sec>\d+)\sBattlEye\sServer:\s'
          GUID = %r{#{TIME}.*Verified\sGUID\s\((?<player_guid>.*?)\).*#\d+?\s(?<player>.+)$}
          CHAT = %r{#{TIME}\((?<channel>Group|Global|Side|Vehicle|Command|Unknown)\)\s+?(?<player>.+?):\s(?<msg>.*)$}

          def initialize(
            include_chat = false,
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

            @incldue_chat
            @to_zulu = to_zulu
            @timezone = timezone
          end

          def parse(loglines)
            loglines.map do |l|
              if GUID.match(l)
                line = {type: :guid}.merge(m_to_h($~))
              elsif @include_chat && CHAT.match(l)
                line = {type: :chat}.merge(m_to_h($~))
              else
                line = nil
              end

              when_am_i!(line) unless line.nil?
            end.compact
          end

          private

          def when_am_i!(line)
            case line[:hour]
            when 4..23
              if Time.now.hour.between?(4, 23)
                t = @timezone.now
              else
                t = @timezone.now - ONE_DAY
              end
              set_line_date!(line, t)
            when 0..3
              set_line_date!(line)
            end
            line
          end

          def set_line_date!(line, time = @timezone.now)
            line[:year] = time.year
            line[:month] = time.month
            line[:day] = time.day
            line
          end
        end
      end
    end
  end
end
