# -*- coding: UTF-8 -*-

require 'rmuh/serverstats/base'

module RMuh
  module ServerStats
    # TODO: Documentation
    #
    class OperationArrowhead < RMuh::ServerStats::Base
      def method_missing(method, *args, &block)
        m = /(.*)/.match(method)[0]
        stats[m]
      end
    end
  end
end
