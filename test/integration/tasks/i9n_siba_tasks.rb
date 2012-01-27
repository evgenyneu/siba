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

    backup_file_name = Siba::FileHelper.entries(dest_dir)[0]
    tasks = Siba::SibaTasks.new options, path_to_test_yml, true
    tasks.restore backup_file_name
  end
end
