# -*- coding: UTF-8 -*-
require_relative 'base'

module RMuh
  module RPT
    module Log
      module Formatters
        # Formatter for the UnitedOperations Log file
        class UnitedOperationsLog < RMuh::RPT::Log::Formatters::Base
          class << self
            def format(event)
              case event[:type]
              when :connect
                format_connect(event)
              when :disconnect
                format_disconnect(event)
              when :beguid
                format_beguid(event)
              when :chat
                format_chat(event)
              else
                nil
              end
            end

            private

            def format_connect(e)
              "#{e[:iso8601]} Server: Player ##{e[:player_num]} " \
              "#{e[:player]} (#{e[:ipaddr]}) connected\n"
            end

            def format_disconnect(e)
              "#{e[:iso8601]} Server: Player #{e[:player]} disconnected\n"
            end

            def format_beguid(e)
              "#{e[:iso8601]} Server: Verified GUID (#{e[:player_beguid]}) " \
              "of player ##{e[:player_num]} #{e[:player]}\n"
            end

            def format_chat(e)
              "#{e[:iso8601]} Chat: (#{e[:channel]}) #{e[:player]}: " \
              "#{e[:message]}\n"
            end
          end
        end
      end
    end
  end
end
