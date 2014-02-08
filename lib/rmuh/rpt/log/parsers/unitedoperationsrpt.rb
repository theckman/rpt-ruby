require 'stringio'
require 'tzinfo'

require 'rmuh/rpt/log/parsers/base'
require 'rmuh/rpt/log/util/unitedoperatireons'
require 'rmuh/rpt/log/util/unitedoperationsrpt'

module RMuh
  module RPT
    module Log
      module Parsers
        # TODO: UnitedOperationsRPT Class Documentation
        #
        class UnitedOperationsRPT < RMuh::RPT::Log::Parsers::Base
          include RMuh::RPT::Log::Util::UnitedOperations
          include RMuh::RPT::Log::Util::UnitedOperationsRPT # Regexp Constants

          def initialize(opts = {})
            validate_opts(opts)

            @to_zulu = opts[:to_zulu].nil? ? true : opts[:to_zulu]
            @timezone = opts[:timezone].nil? ? UO_TZ : opts[:timezone]
          end

          def validate_opts(opts)
            validate_to_zulu(opts)
            validate_timezone(opts)
          end

          def parse(loglines)
            unless loglines.is_a?(StringIO)
              fail ArgumentError, 'argument 1 must be a StringIO object'
            end

            loglines.map do |l|
              line = regex_match(l)
              zulu!(line, @timezone) if @to_zulu && !line.nil?
              add_guid!(line) unless line.nil?
            end.compact
          end

          private

          def regex_match(l)
            if ANNOUNCEMENT.match(l)
              line = { type: :announcement }.merge(m_to_h($LAST_MATCH_INFO))
            elsif WOUNDED.match(l)
              line = { type: :wounded }.merge(m_to_h($LAST_MATCH_INFO))
            elsif KILLED.match(l)
              line = { type: :killed }.merge(m_to_h($LAST_MATCH_INFO))
            elsif DIED.match(l)
              line = { type: :died }.merge(m_to_h($LAST_MATCH_INFO))
            end
            (defined?(line)) ? line : nil
          end
        end
      end
    end
  end
end
