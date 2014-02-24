# -*- coding: UTF-8 -*-

require 'rmuh/serverstats/base'

module RMuh
  module ServerStats
    # TODO: Documentation
    #
    class OperationArrowhead < RMuh::ServerStats::Base
      def method_missing(method, *args, &block)
        super unless stats.key?(method)
        stats[method]
      end
    end
  end
end
