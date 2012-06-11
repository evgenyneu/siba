# encoding: UTF-8

require 'helper/require_unit'

describe Siba::OptionsBackup do
  before do
    @cls = Siba::OptionsBackup
    @yml_path = File.expand_path('../yml', __FILE__)
  end

  it "should call save_options_backup" do
    @cls.save_options_backup File.join(@yml_path, "valid.yml"), "/dir"
  end

  it "should call load_source_from_backup" do
    options = load_options Siba::OptionsBackup::OPTIONS_BACKUP_FILE_NAME
    new_task = @cls.load_source_from_backup @yml_path
    new_task.must_be_instance_of Siba::SibaTask
    Siba.current_dir.must_equal options["current_dir"]
  end
end
