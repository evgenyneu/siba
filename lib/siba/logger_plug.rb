# encoding: UTF-8

require 'siba/siba_logger'

module Siba
  # Used to inject "logger" to classes that include this module
  module LoggerPlug
    def logger
      LoggerPlug.logger
    end

    class << self
      def logger
        raise Siba::Error, "Log is not created" unless LoggerPlug.opened?
        @logger
      end    

      def create(name, path_to_log_file, show_start_message = true)
        raise Siba::Error, "Log is already created" if LoggerPlug.opened?
        @logger = SibaLogger.new name, path_to_log_file, show_start_message
      end

      def close
        @logger.close if LoggerPlug.opened?
        @logger = nil
        SibaLogger.quiet = false
        SibaLogger.verbose = false
        SibaLogger.no_log = false
      end

      def opened?
        !@logger.nil?
      end
    end
  end
end
