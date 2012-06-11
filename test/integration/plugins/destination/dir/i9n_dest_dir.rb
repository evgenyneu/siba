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

  it "should get list of backups and restore them to dir" do
    prefix = "bak"
    prepare_test_file prefix
    file_to_restore = prepare_test_file prefix
    prepare_test_file prefix
    prepare_test_file "different"
    @obj = @cls.new SibaTest.tmp_dir
    list = @obj.get_backups_list prefix
    list.must_be_instance_of Array
    list.size.must_equal 3
    list[0].size.must_equal 2
    list[0][0].must_be_instance_of String
    list[0][1].must_be_instance_of Time

    # Restore backups to dir
    file_name = File.basename file_to_restore
    restore_dir = mkdir_in_tmp_dir "rst"
    @obj.restore_backup_to_dir file_name, restore_dir
    file_restored = File.join restore_dir, file_name
    File.file?(file_restored).must_equal true
    file_to_restore.wont_equal file_restored
    FileUtils.compare_file(file_to_restore, file_restored).must_equal true
  end
end
