# encoding: UTF-8

require 'helper/require_integration'

describe Siba::Backup do
  before do
    @yml_path = File.expand_path '../yml', __FILE__
    @path_to_src_yml = File.join @yml_path, "valid.yml"
  end

  it "should run backup and restore" do
    Siba::LoggerPlug.close
    Siba::SibaLogger.quiet = true

    src_dir = prepare_test_dir "bf-src-dir"
    src_file = prepare_test_file "bf-src-file"
    dest_dir = mkdir_in_tmp_dir "bf-dest-dir"

    test_yml_path = prepare_yml @path_to_src_yml, 
      { src_dir: src_dir,
        src_file: src_file,
        dest_dir: dest_dir }

    log_file = File.join File.dirname(test_yml_path), "testlog.log"

    # Test backup
    Siba::Backup.new.backup test_yml_path, log_file
    Siba::FileHelper.entries(dest_dir).find{|a| a =~ /\.gpg$/}.wont_be_nil
    siba_file.file_file?(log_file).must_equal true, "Must create log file"
    Siba.tmp_dir_clean?.must_equal true, "Tmp dir must be cleaned"
    Siba::LoggerPlug.opened?.must_equal false, "Logger must be closed"

    # Test restore
    Siba::SibaLogger.quiet = true
    SibaTest::KernelMock.gets_return_value = "1"
    Siba::Restore.new.restore test_yml_path
    wont_log_from "warn"
  end
end
