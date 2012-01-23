# encoding: UTF-8
require 'logger'

module Siba
  class SibaLogger
    LogLevels = %w(debug info warn error fatal unknown)

    class << self
      attr_accessor :quiet, :verbose, :no_log, :messages

      def log_level?(level)
        SibaLogger::LogLevels.include? level
      end

      def check_log_level(level)
        raise "Unsupported log level '#{level}'" unless SibaLogger::log_level? level
      end

      def level_to_i(level)
        check_log_level level
        SibaLogger::LogLevels.index level
      end

      def count(severity=nil, exact_level=true)
        return 0 if SibaLogger.messages.nil?
        return SibaLogger.messages.size if severity.nil?
        severity_i = SibaLogger.level_to_i severity
        SibaLogger.messages.count do |i| 
          if exact_level 
            i.level == severity_i 
          else 
            i.level >= severity_i
          end
        end
      end
    end

    attr_accessor :finish_success_msg

    def initialize(name, path_to_log_file)
      @name = name
      SibaLogger.messages = []
      @loggers = []

      @strlog = StringIO.new
      @loggers << Logger.new(@strlog)

      unless SibaLogger.quiet
        @stdout_log = Logger.new(STDOUT) 
        @loggers << stdout_log
      end

      unless path_to_log_file.nil? || SibaLogger.no_log
        @file = File.open(path_to_log_file, "a:utf-8")
        @file_log = Logger.new(file) 
        @loggers << file_log
      end

      @loggers.each do |logger|
        logger.formatter = method(:formatter)
      end

      file_log.info "
||----------NEW LOG----------||
|| #{Time.now} ||
||---------------------------||
" unless file_log.nil?

      info "#{name} started" unless name.nil?
    end

    def to_s
      strlog.string
    end

    def close
      if SibaLogger.count('fatal') > 0
        info "#{name} failed"
      elsif SibaLogger.count('warn', false) == 0
        if finish_success_msg
          info finish_success_msg
        else
          info "#{name} finished successfully"
        end
      else
        info "#{name} completed with some issues"
      end

      unless file.nil?
        file.close
      end

      unless file_log.nil?
        file_log.close
      end
      @loggers = []
      @strlog = nil
      @file_log = nil
      @file = nil
      @stdout_log = nil
    end

    def warn(*args, &block)
      log('warn', *args, &block)
    end

    def log_exception(exception, log_only_backtrace=false)
      log('debug',exception.message) unless log_only_backtrace
      unless exception.backtrace.nil?
        log('debug',"\n--- stack trace ---\n#{exception.backtrace.join("\n")}\n--- stack trace ---") 
      end
    end

    def method_missing(meth, *args, &block)
      if SibaLogger::log_level? meth.to_s
        log(meth.to_s, *args, &block)
      else
        super
      end
    end

    def respond_to?(meth)
      if SibaLogger::log_level? meth.to_s
        true
      else
        super
      end
    end

  private
    attr_accessor :loggers, :name, :strlog, :file_log, :stdout_log, :file

    def log(level, *args, &block)
      raise Siba::Error, "Log is closed" if loggers.empty?
      level_i = SibaLogger::level_to_i level
      unless block.nil?
        msg = block.call.to_s
      else
        assert "Wrong number of arguments" if args.size != 1
        msg = args[0].to_s
      end

      log_message = LogMessage.new
      log_message.level = level_i
      log_message.time = Time.now
      log_message.msg = msg
      SibaLogger.messages << log_message

      loggers.each do |l|
        l.send(level, msg) unless l == stdout_log
      end

      unless stdout_log.nil?
        stdout_log.send(level, EncodingHelper.encode_to_external(msg)) unless level == 'debug' && !SibaLogger.verbose
      end
    end

    def formatter(severity, datetime, progname, msg)
      if ["INFO", "DEBUG"].include? severity
        severity = ""
      else
        severity = "WARNING" if severity == "WARN"
        severity += " - "
      end

      "#{severity}#{msg}\n"
    end
  end

  class LogMessage
    attr_accessor :level, :time, :msg
  end
end
