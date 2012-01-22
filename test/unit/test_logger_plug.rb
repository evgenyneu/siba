# encoding: UTF-8

require 'helper/require_unit'

describe Siba::LoggerPlug do
  describe "when accessing LoggerPlug class" do
    it "must have logger" do
      Siba::LoggerPlug.logger.wont_be_nil
    end

    it "must have logger of type SibaLogger" do
      Siba::LoggerPlug.logger.must_be_instance_of Siba::SibaLogger 
    end

    it "must include logger instance method" do
      Siba::LoggerPlug.instance_methods.must_include :logger
    end

    it "must call opened?" do
      Siba::LoggerPlug.opened?.must_equal true, "should be opened"
      Siba::LoggerPlug.close
      Siba::LoggerPlug.opened?.must_equal false, "should be closed"
    end

    it "must call close" do
      Siba::SibaLogger.quiet = true
      Siba::SibaLogger.verbose = true
      Siba::SibaLogger.no_log = true
      Siba::LoggerPlug.close
      Siba::SibaLogger.quiet.must_equal false
      Siba::SibaLogger.verbose.must_equal false
      Siba::SibaLogger.no_log.must_equal false
    end
  end
end
