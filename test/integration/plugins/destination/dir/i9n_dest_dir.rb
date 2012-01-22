# encoding: UTF-8

require 'helper/require_integration'
require 'siba/plugins/destination/dir/init'

describe Siba::Destination::Dir::DestDir do
  it "should init" do
    dest_dir = mkdir_in_tmp_dir "test-dest-dir"
    Siba::Destination::Dir::DestDir.new dest_dir

    siba_file.file_directory?(dest_dir).must_equal true, "Should create dest dir on init"
    Siba::FileHelper.dir_empty?(dest_dir).must_equal true, "Must remove test file from dest dir"
  end

  it "should copy backup to dest dir" do
    dest_dir = mkdir_in_tmp_dir "test-dest-dir"
    dir_dest = Siba::Destination::Dir::DestDir.new dest_dir
    backup_file = prepare_test_file "destination-dir-backup"
    dir_dest.copy_backup_to_dest backup_file
    path_to_dest_file = File.join dest_dir, File.basename(backup_file)
    siba_file.file_file?(path_to_dest_file).must_equal true
    siba_file.file_utils_compare_file(backup_file, path_to_dest_file).must_equal true
  end
end
