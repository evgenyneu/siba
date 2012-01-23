# encoding: UTF-8

require 'helper/require_unit' 

describe Siba::Backup do
  before do
    @yml_path = File.expand_path('../yml', __FILE__)
  end
  
  it "should call backup_backup_from_options_file" do
    Siba::LoggerPlug.close
    Siba::SibaLogger.quiet = true
    path_to_options_file = File.join @yml_path, "valid.yml"
    Siba::Backup.new.backup path_to_options_file, nil
    wont_log_from "warn"
    Siba.tmp_dir_clean?.must_equal true
  end
end
