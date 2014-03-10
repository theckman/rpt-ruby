# -*- coding: UTF-8 -*-

require 'rmuh/serverstats/base'

module RMuh
  module ServerStats
    # This is an advanced extension of the Base class. This adds the ability to
    # access the top level keys returned from the server using dot notation
    #
    # No additions / alterations exist to the methods from the Base class
    #
    class Advanced < RMuh::ServerStats::Base
      def method_missing(method, *args, &block)
        super unless stats.key?(method.to_s)
        stats[method.to_s]
      end
    end
  end
end
