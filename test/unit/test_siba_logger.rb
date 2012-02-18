# encoding: UTF-8

require 'helper/require_unit'

describe Siba::SibaLogger do
  before do
    @logger = Siba::SibaLogger.new "Test", nil
    @cls = Siba::SibaLogger
  end

  describe "when access class" do
    it "must access quiet" do
      @cls.quiet = true
      @cls.quiet.must_equal true 
    end
    
    it "must access verbose" do
      @cls.verbose = true
      @cls.verbose.must_equal true 
    end
    
    it "must access no_log" do
      @cls.no_log = true
      @cls.no_log.must_equal true 
    end

    it "must contain LogLevels" do
      @cls::LogLevels.must_include "debug"  
      @cls::LogLevels.must_include "info"  
      @cls::LogLevels.must_include "warn"  
      @cls::LogLevels.must_include "error"  
      @cls::LogLevels.must_include "fatal"  
      @cls::LogLevels.must_include "unknown"  
    end

    it "must check given log level" do
      @cls.log_level?("info").must_equal true
      @cls.log_level?("chelyabinsk").must_equal false
    end

    it "must have check_log_level method" do
      @cls::check_log_level "info"
    end

    it "check_log_level must raise for unsupported level" do
      -> { @cls::check_log_level("weird") }.must_raise RuntimeError 
    end

    it "must return log level integer" do
      @cls.level_to_i("debug").must_equal 0
      @cls.level_to_i("info").must_equal 1
      @cls.level_to_i("warn").must_equal 2
      @cls.level_to_i("error").must_equal 3
      @cls.level_to_i("fatal").must_equal 4
      @cls.level_to_i("unknown").must_equal 5
    end

    it "must call count" do
      @cls.count.must_equal 1
    end

    it "count should work when logger is closed" do
      Siba::LoggerPlug.close
      @cls.messages = nil
      @cls.count("warn").must_equal 0
    end
  end

  describe "when access logger" do
    it "must initialize SibaLogger" do
      @logger.wont_be_nil
      @cls.count("info").must_equal 1, "Must contain 'log start' message"
    end

    it "must initialize variables" do
      @cls.messages.must_be_instance_of Array
      @cls.count.must_equal 1
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

      @cls.messages.size.must_equal 4
      @cls.messages[1].must_be_instance_of Siba::LogMessage
      @cls.messages[1].msg.must_equal "msg1"
      @cls.messages[1].level.must_equal @cls.level_to_i("debug")
      @cls.messages[1].time.must_be_instance_of Time 
      @cls.messages[3].msg.must_equal "msg3"
      @cls.messages[3].level.must_equal @cls.level_to_i("warn")
    end
    
    it "should raise when called missing method" do
      ->{ @logger.this_is_a_missing_method("msg") }.must_raise NoMethodError
    end

    it "should log on different levels" do
      @cls::LogLevels.each do |level|
        @cls.count(level, true).must_equal (level == "info" ? 1 : 0)
      end 

      @cls::LogLevels.each do |level|
        @logger.send(level,"#{level} message")
      end

      @cls::LogLevels.each do |level|
        @cls.count(level, true).must_equal (level == "info" ? 2 : 1)
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

      @cls.count.must_equal 11
      @cls.count("debug", false).must_equal 11
      @cls.count("debug").must_equal 1
      @cls.count("info", false).must_equal 10
      @cls.count("info").must_equal 3
      @cls.count("warn", false).must_equal 7
      @cls.count("error", false).must_equal 6
      @cls.count("error").must_equal 3
      @cls.count("fatal", false).must_equal 3
      @cls.count("fatal", true).must_equal 2
    end

    it "should count messages in logs" do
      @logger.debug "debug1"
      @logger.debug "shared"
      @logger.info "shared"
      @logger.info "info1"
      @logger.info "info2"
      @logger.error "shared"
      @logger.error "err1"
      @logger.error "err2"
      @logger.error "err3"
      
      @cls.count_messages("debug1").must_equal 1
      @cls.count_messages("debug1", "debug").must_equal 1
      @cls.count_messages("debug", "debug").must_equal 1
      @cls.count_messages("hola", "debug").must_equal 0
      @cls.count_messages("hola").must_equal 0

      @cls.count_messages("info1").must_equal 1
      @cls.count_messages("info2").must_equal 1
      @cls.count_messages("info").must_equal 2
      @cls.count_messages("info", "debug").must_equal 0
      @cls.count_messages("info", "debug", false).must_equal 2
      @cls.count_messages("info", "info").must_equal 2
      @cls.count_messages("info", "warn").must_equal 0
      
      @cls.count_messages("err").must_equal 3
      @cls.count_messages("err", "error").must_equal 3
      @cls.count_messages("err1", "error").must_equal 1

      @cls.count_messages("shared", "info").must_equal 1
      @cls.count_messages("shared", "debug").must_equal 1
      @cls.count_messages("shared", "error").must_equal 1
      @cls.count_messages("shared").must_equal 3
    end

    it "must call log_exception" do
      @logger.log_exception Exception.new "hello"
      @cls.count("debug",true).must_equal 1
    end

    it "must call log backtrace with_exception" do
      ex = Exception.new "hello"
      ex.set_backtrace ["one","two","tree"]
      @logger.log_exception ex
      @cls.count("debug",true).must_equal 2
    end

    it "must close logger" do
      @logger.close
      @cls.count.must_equal 2
      ->{@logger.info "hi"}.must_raise Siba::Error, "Error if trying to use closed log"
    end

    it "to_s should show logs string" do
      test_message = "this is a test message"
      @logger.info test_message
      @logger.to_s.must_match /#{test_message}$/
    end

    it "should access :show_finish_message" do
      @logger.show_finish_message = false
      @logger.close
      @cls.messages.size.must_equal 1
    end
  end
end
