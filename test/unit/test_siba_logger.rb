# encoding: UTF-8

require 'helper/require_unit'

describe Siba::SibaLogger do
  before do
    @logger = Siba::SibaLogger.new "Test", nil
  end

  describe "when access class" do
    it "must access quiet" do
      Siba::SibaLogger.quiet = true
      Siba::SibaLogger.quiet.must_equal true 
    end
    
    it "must access verbose" do
      Siba::SibaLogger.verbose = true
      Siba::SibaLogger.verbose.must_equal true 
    end
    
    it "must access no_log" do
      Siba::SibaLogger.no_log = true
      Siba::SibaLogger.no_log.must_equal true 
    end

    it "must contain LogLevels" do
      Siba::SibaLogger::LogLevels.must_include "debug"  
      Siba::SibaLogger::LogLevels.must_include "info"  
      Siba::SibaLogger::LogLevels.must_include "warn"  
      Siba::SibaLogger::LogLevels.must_include "error"  
      Siba::SibaLogger::LogLevels.must_include "fatal"  
      Siba::SibaLogger::LogLevels.must_include "unknown"  
    end

    it "must check given log level" do
      Siba::SibaLogger.log_level?("info").must_equal true
      Siba::SibaLogger.log_level?("chelyabinsk").must_equal false
    end

    it "must have check_log_level method" do
      Siba::SibaLogger::check_log_level "info"
    end

    it "check_log_level must raise for unsupported level" do
      -> { Siba::SibaLogger::check_log_level("weird") }.must_raise RuntimeError 
    end

    it "must return log level integer" do
      Siba::SibaLogger.level_to_i("debug").must_equal 0
      Siba::SibaLogger.level_to_i("info").must_equal 1
      Siba::SibaLogger.level_to_i("warn").must_equal 2
      Siba::SibaLogger.level_to_i("error").must_equal 3
      Siba::SibaLogger.level_to_i("fatal").must_equal 4
      Siba::SibaLogger.level_to_i("unknown").must_equal 5
    end

    it "must call count" do
      Siba::SibaLogger.count.must_equal 1
    end

    it "count should work when logger is closed" do
      Siba::LoggerPlug.close
      Siba::SibaLogger.messages = nil
      Siba::SibaLogger.count("warn").must_equal 0
    end
  end

  describe "when access logger" do
    it "must initialize SibaLogger" do
      @logger.wont_be_nil
      Siba::SibaLogger.count("info").must_equal 1, "Must contain 'log start' message"
    end

    it "must initialize variables" do
      Siba::SibaLogger.messages.must_be_instance_of Array
      Siba::SibaLogger.count.must_equal 1
    end

    it "should call log methods" do
      @logger.debug "msg"
      @logger.info "msg"
      @logger.warn "msg"
      @logger.error "msg"
      @logger.fatal "msg"
      @logger.unknown "msg"
    end

    it "should contains messages" do
      @logger.debug "msg1"
      @logger.info "msg2"
      @logger.warn "msg3"

      Siba::SibaLogger.messages.size.must_equal 4
      Siba::SibaLogger.messages[1].must_be_instance_of Siba::LogMessage
      Siba::SibaLogger.messages[1].msg.must_equal "msg1"
      Siba::SibaLogger.messages[1].level.must_equal Siba::SibaLogger.level_to_i("debug")
      Siba::SibaLogger.messages[1].time.must_be_instance_of Time 
      Siba::SibaLogger.messages[3].msg.must_equal "msg3"
      Siba::SibaLogger.messages[3].level.must_equal Siba::SibaLogger.level_to_i("warn")
    end
    
    it "should raise when called missing method" do
      ->{ @logger.this_is_a_missing_method("msg") }.must_raise NoMethodError
    end

    it "should log on different levels" do
      Siba::SibaLogger::LogLevels.each do |level|
        Siba::SibaLogger.count(level, true).must_equal (level == "info" ? 1 : 0)
      end 

      Siba::SibaLogger::LogLevels.each do |level|
        @logger.send(level,"#{level} message")
      end

      Siba::SibaLogger::LogLevels.each do |level|
        Siba::SibaLogger.count(level, true).must_equal (level == "info" ? 2 : 1)
      end 
    end

    it "count must return correct number of message for severity lever" do
      @logger.debug "msg1"
      @logger.info "msg2"
      @logger.info "msg3"
      @logger.warn "msg4"
      @logger.error "msg5"
      @logger.error "msg6"
      @logger.error "msg7"
      @logger.fatal "msg8"
      @logger.fatal "msg9"
      @logger.unknown "msg10"

      Siba::SibaLogger.count.must_equal 11
      Siba::SibaLogger.count("debug", false).must_equal 11
      Siba::SibaLogger.count("debug").must_equal 1
      Siba::SibaLogger.count("info", false).must_equal 10
      Siba::SibaLogger.count("info").must_equal 3
      Siba::SibaLogger.count("warn", false).must_equal 7
      Siba::SibaLogger.count("error", false).must_equal 6
      Siba::SibaLogger.count("error").must_equal 3
      Siba::SibaLogger.count("fatal", false).must_equal 3
      Siba::SibaLogger.count("fatal", true).must_equal 2
    end

    it "must call log_exception" do
      @logger.log_exception Exception.new "hello"
      Siba::SibaLogger.count("debug",true).must_equal 1
    end

    it "must call log backtrace with_exception" do
      ex = Exception.new "hello"
      ex.set_backtrace ["one","two","tree"]
      @logger.log_exception ex
      Siba::SibaLogger.count("debug",true).must_equal 2
    end

    it "must close logger" do
      @logger.close
      Siba::SibaLogger.count.must_equal 2
      ->{@logger.info "hi"}.must_raise Siba::Error, "Error if trying to use closed log"
    end

    it "to_s should show logs string" do
      test_message = "this is a test message"
      @logger.info test_message
      @logger.to_s.must_match /#{test_message}$/
    end

    it "should access :finish_success_msg" do
      @logger.finish_success_msg = "Hi"
      @logger.close
      Siba::SibaLogger.messages.last.msg.must_equal "Hi"
    end
  end
end
