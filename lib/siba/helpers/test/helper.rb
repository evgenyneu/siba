# encoding: UTF-8

module SibaTest
  IS_WINDOWS = !(RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/).nil?
  UNICODE_FILE_NAME = "алиен学"
  TmpDirMocked = "/tmp"

  class << self
    include Siba::TmpDirPlug

    attr_accessor :setup_hooks
    attr_accessor :teardown_hooks

    def init
      require 'minitest/pride' unless SibaTest::IS_WINDOWS

      @loaded_options = {}
      @current_dir = siba_file.file_utils_pwd
      @setup_hooks = []
      @teardown_hooks = []

      @setup_hooks << -> do
        Siba::SibaLogger.quiet = true
        Siba::SibaLogger.no_log = true
        Siba::LoggerPlug.create "Test", nil
        Siba::SibaLogger.messages = []
        Siba.settings = {}
        Siba.current_dir = @current_dir
        Siba.backup_name = "siba"
        SibaTest::KernelMock.mock_all_methods # prevents tests from accessing Kernel methods
      end

      @teardown_hooks << -> { Siba::LoggerPlug.close }
    end

    def init_unit
      init
      @setup_hooks << -> do
        SibaTest::FileMock.mock_all_methods # prevents tests from doing file operations
        Siba.class_eval {@tmp_dir = SibaTest::TmpDirMocked}
      end
    end

    def init_integration
      init
      @teardown_hooks << -> do
        # cleanup after each integration test
        Siba.current_dir = @current_dir
        Siba.cleanup_tmp_dir
        SibaTest.cleanup_tmp_dir
      end
    end

    def load_options(path_to_yml)
      @loaded_options[path_to_yml] ||= Siba::OptionsLoader.load_yml(path_to_yml)
    end
  end
end
