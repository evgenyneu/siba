# encoding: UTF-8

require 'helper/require_integration'

describe Siba::Backup do
  before do
    @yml_path = File.expand_path '../yml', __FILE__
    @path_to_src_yml = File.join @yml_path, "valid.yml"
    skip if SibaTest::IS_WINDOWS # Unicode paths do not work on Windows
  end

  it "should create folders and files with unicode names" do
    dir_path = prepare_test_dir SibaTest::UNICODE_FILE_NAME
    File.directory?(dir_path).must_equal true

    file_path = prepare_test_file SibaTest::UNICODE_FILE_NAME
    File.file?(file_path).must_equal true
  end

  it "should backup with unicode files and dirs" do
    @backup = Siba::Backup.new
    Siba::LoggerPlug.close
    Siba::SibaLogger.quiet = true
    src_dir = prepare_test_dir "bf-src-dir-#{SibaTest::UNICODE_FILE_NAME}"
    prepare_test_dir SibaTest::UNICODE_FILE_NAME, src_dir
    prepare_test_file SibaTest::UNICODE_FILE_NAME, src_dir
    src_file = prepare_test_file "bf-src-file-#{SibaTest::UNICODE_FILE_NAME}"
    dest_dir = mkdir_in_tmp_dir "bf-dest-dir-#{SibaTest::UNICODE_FILE_NAME}"

    test_yml_path = prepare_yml @path_to_src_yml, 
      { src_dir: src_dir,
        src_file: src_file,
        dest_dir: dest_dir,
        password: %("#{Siba::SecurityHelper.generate_password_for_yaml}")  }


    log_file = File.join File.dirname(test_yml_path), "testlog.log"
    @backup.backup test_yml_path, log_file
    Siba::FileHelper.entries(dest_dir).find{|a| a =~ /\.gpg$/}.wont_be_nil
    wont_log_from "warn"
  end
end
