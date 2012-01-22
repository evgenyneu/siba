# encoding: UTF-8

require 'helper/require_integration'

describe Siba::SibaTasks do
  before do
    @yml_path = File.expand_path '../../yml', __FILE__
    @path_to_src_yml = File.join @yml_path, "valid.yml"
  end

  it "should backup tasks" do
    src_dir = prepare_test_dir "b-src-dir" 
    src_file = prepare_test_file "b-src-file"
    dest_dir = mkdir_in_tmp_dir "b-dest-dir"

    path_to_test_yml = prepare_yml @path_to_src_yml,
      { src_dir: src_dir,
        src_file: src_file,
        dest_dir: dest_dir }

    options = SibaTest.load_options path_to_test_yml

    tasks = Siba::SibaTasks.new options, path_to_test_yml
    tasks.backup 
    options_backup = File.join(tasks.source_dir, Siba::SibaTasks::OPTIONS_BACKUP_FILE_NAME)
    File.file?(options_backup).must_equal true, "Must save options backup"
    siba_file.file_utils_compare_file(options_backup, path_to_test_yml).must_equal true
  end
end
