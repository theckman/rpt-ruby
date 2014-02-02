module RMuh
  module RPT
    module Log
      module Parsers
        class Base
          def initialize

          end

          def parse(loglines)
            raise ArgumentError, 'argument 1 must be a StringIO object' unless loglines.is_a? StringIO
            lines = loglines.map do |line|
              {:type => :log, :message => line}
            end
          end
        end
      end
    end
  end
end
