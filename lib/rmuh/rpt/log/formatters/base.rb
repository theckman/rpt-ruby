# -*- coding: UTF-8 -*-

module RMuh
  module RPT
    module Log
      module Formatters
        # RPT Log Formatter base class
        class Base
          class << self
            def format(event)
              "#{event[:message]}" if event[:type] == :log
            end
          end
        end
      end
    end
  end
end
