# encoding: UTF-8

require 'helper/require_integration'

describe Siba::OptionsBackup do
  before do
    @cls = Siba::OptionsBackup
  end

  it "should save options backup" do
    new_curret_dir = "change_current_dir"
    Siba.current_dir = new_curret_dir
    yml_path = File.expand_path "../yml", __FILE__
    options_path = File.join yml_path, "valid.yml"
    source_dir = mkdir_in_tmp_dir "sob"
    @cls.save_options_backup options_path, source_dir
    options_backup_path = File.join source_dir, Siba::OptionsBackup::OPTIONS_BACKUP_FILE_NAME
    @yml_path = source_dir
    options = load_options Siba::OptionsBackup::OPTIONS_BACKUP_FILE_NAME
    options["current_dir"].must_equal new_curret_dir
  end
end
