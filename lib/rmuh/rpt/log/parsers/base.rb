# -*- coding: UTF-8 -*-
module RMuh
  module RPT
    module Log
      module Parsers
        # This is the base RPT parser class. This does nothing but
        # return each line as a Hash within an Array. There is no
        # metadata extracted, it's a literal copy and paste of the
        # provided log line. This class is primarily used as an example
        # class to be used for subclassing of your own parser
        #
        class Base
          def initialize(_opts = {})
          end

          def parse(loglines)
            fail(
              ArgumentError, 'argument 1 must be a StringIO object'
            ) unless loglines.is_a?(StringIO)

            loglines.map { |line| { type: :log, message: line } }
          end
        end
      end
    end
  end
end
