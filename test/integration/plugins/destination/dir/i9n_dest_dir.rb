# encoding: UTF-8

require 'helper/require_integration'
require 'siba/plugins/destination/dir/init'

describe Siba::Destination::Dir::DestDir do
  before do    
    @cls = Siba::Destination::Dir::DestDir
  end

  it "should init" do
    dest_dir = mkdir_in_tmp_dir "test-dest-dir"
    @cls.new dest_dir

    siba_file.file_directory?(dest_dir).must_equal true, "Should create dest dir on init"
    Siba::FileHelper.dir_empty?(dest_dir).must_equal true, "Must remove test file from dest dir"
  end

  it "should copy backup to dest dir" do
    dest_dir = mkdir_in_tmp_dir "test-dest-dir"
    dir_dest = @cls.new dest_dir
    backup_file = prepare_test_file "destination-dir-backup"
    dir_dest.copy_backup_to_dest backup_file
    path_to_dest_file = File.join dest_dir, File.basename(backup_file)
    siba_file.file_file?(path_to_dest_file).must_equal true
    siba_file.file_utils_compare_file(backup_file, path_to_dest_file).must_equal true
  end

  it "should get list of backups" do
    prefix = "bak"
    prepare_test_file prefix
    prepare_test_file prefix
    prepare_test_file prefix
    prepare_test_file "different"
    list = @cls.new(SibaTest.tmp_dir).get_backups_list prefix
    list.must_be_instance_of Array
    list.size.must_equal 3
    list[0].size.must_equal 2
    list[0][0].must_be_instance_of String
    list[0][1].must_be_instance_of Time
  end
end
