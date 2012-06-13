# encoding: UTF-8

module SibaTest
  IS_WINDOWS = !(RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/).nil?
  UNICODE_FILE_NAME = "алиен学"
  TmpDirMocked = "/tmp"

  class << self
    include Siba::TmpDirPlug

    def init
      require 'minitest/pride' unless SibaTest::IS_WINDOWS

      @loaded_options = {}
      @current_dir = siba_file.file_utils_pwd

      MiniTest::Unit::TestCase.add_setup_hook do
        Siba::SibaLogger.quiet = true
        Siba::SibaLogger.no_log = true
        Siba::LoggerPlug.create "Test", nil
        Siba::SibaLogger.messages = []
        Siba.settings = {}
        Siba.current_dir = @current_dir
        Siba.backup_name = "siba"
        SibaTest::KernelMock.mock_all_methods # prevents tests from accessing Kernel methods
      end

      MiniTest::Unit::TestCase.add_teardown_hook do
        Siba::LoggerPlug.close
      end
    end

    def init_unit
      init
      MiniTest::Unit::TestCase.add_setup_hook do
        SibaTest::FileMock.mock_all_methods # prevents tests from doing file operations
        Siba.class_eval {@tmp_dir = SibaTest::TmpDirMocked}
      end
    end

    def init_integration
      init
      MiniTest::Unit::TestCase.add_teardown_hook do
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
