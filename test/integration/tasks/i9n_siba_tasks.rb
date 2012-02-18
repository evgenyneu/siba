# encoding: UTF-8

require 'helper/require_integration'

describe Siba::SibaTasks do
  before do
    @yml_path = File.expand_path '../../yml', __FILE__
    @path_to_src_yml = File.join @yml_path, "valid.yml"
  end

  it "should backup and testore tasks" do
    src_dir = prepare_test_dir "b-src-dir" 
    src_file = prepare_test_file "b-src-file"
    dest_dir = mkdir_in_tmp_dir "b-dest-dir"

    path_to_test_yml = prepare_yml @path_to_src_yml,
      { src_dir: src_dir,
        src_file: src_file,
        dest_dir: dest_dir }

    options = SibaTest.load_options path_to_test_yml

    tasks = Siba::SibaTasks.new options, path_to_test_yml, false
    tasks.backup 

    # restore into original source
    backup_file_name = Siba::FileHelper.entries(dest_dir)[0]
    tasks = Siba::SibaTasks.new options, path_to_test_yml, true
    tasks.tasks["source"].must_be_nil # should not load source before restore
    tasks.restore backup_file_name
    tasks.tasks["source"].wont_be_nil # source should be loaded on restore

    # restore into curret source
    backup_file_name = Siba::FileHelper.entries(dest_dir)[0]
    tasks = Siba::SibaTasks.new options, path_to_test_yml, false
    tasks.tasks["source"].wont_be_nil # should load current source on tasks init
    source = tasks.tasks["source"]
    tasks.restore backup_file_name
    tasks.tasks["source"].must_equal source # should use current source during restore
  end
end
