# encoding: UTF-8

require 'helper/require_integration'
require 'siba/plugins/source/files/files'

describe Siba::Source::Files::Files do
  before do
    @files = Siba::Source::Files::Files
  end

  it "should run copy_file" do
    src_file = prepare_test_file "s-f"
    dest_dir = mkdir_in_tmp_dir "s-f-dest"
    f = @files.new [],[],true
    f.copy_file src_file, dest_dir
    dest_file = File.join dest_dir, File.basename(src_file)
    src_file.wont_equal dest_file
    siba_file.file_file?(dest_file).must_equal true
    siba_file.file_utils_compare_file(src_file, dest_file).must_equal true
  end

  it "copy_file should not copy file if it's ignored" do
    src_file = prepare_test_file "s-f"
    dest_dir = mkdir_in_tmp_dir "s-f-dest"
    f = @files.new [],["*"],true
    f.copy_file src_file, dest_dir
    dest_file = File.join dest_dir, File.basename(src_file)
    src_file.wont_equal dest_file
    siba_file.file_file?(dest_file).must_equal false
  end

  it "should run copy_dir" do
    src_dir = prepare_test_dir "s-f-src-dir"
    dest_dir = mkdir_in_tmp_dir "s-f-dest-dir"
    f = @files.new [],[],true
    f.copy_dir src_dir, dest_dir, true
    dest_sub_dir = File.join dest_dir, File.basename(src_dir)
    siba_file.file_directory?(dest_sub_dir).must_equal true
    dirs_same? src_dir, dest_sub_dir
  end

  it "run copy_dir wihout including subdirs" do
    src_dir = prepare_test_dir "s-f-src-dir"
    dest_dir = mkdir_in_tmp_dir "s-f-dest-dir"
    f = @files.new [],[],false
    f.copy_dir src_dir, dest_dir, true
    dest_sub_dir = File.join dest_dir, File.basename(src_dir)
    Siba::FileHelper.entries(src_dir).each do |entry|
      entry_path = File.join src_dir, entry
      siba_file.file_utils_remove_entry_secure entry_path if siba_file.file_directory?(entry_path) 
    end
    siba_file.file_directory?(dest_sub_dir).must_equal true
    dirs_same? src_dir, dest_sub_dir
  end

  it "copy_dir should not copy if it's ignored" do
    src_dir = prepare_test_dir "s-f-src-dir"
    dest_dir = mkdir_in_tmp_dir "s-f-dest-dir"
    f = @files.new [],["*"],true
    f.copy_dir src_dir, dest_dir, true
    dest_sub_dir = File.join dest_dir, File.basename(src_dir)
    siba_file.file_directory?(dest_sub_dir).must_equal false
  end

  it "copy_dir should not create a sub dir" do
    src_dir = prepare_test_dir "s-f-src-dir"
    dest_dir = mkdir_in_tmp_dir "s-f-dest-dir"
    f = @files.new [],[],true
    f.copy_dir src_dir, dest_dir, false
    dirs_same? src_dir, dest_dir
  end

  it "backup should copy dir and file" do
    src_dir = prepare_test_dir "s-f-src-dir"
    src_file = prepare_test_file "s-f-src-file"
    f = @files.new [src_dir, src_file],[],true

    dest_dir = mkdir_in_tmp_dir "s-f-dest-dir"
    f.backup dest_dir
   
    # compare dir 
    backup_dir = @files.sub_dir_name 1, 1, false, File.basename(src_dir), dest_dir
    dirs_same? src_dir, backup_dir

    # compare file
    backup_file_dir = @files.sub_dir_name 2, 1, true, File.basename(src_file), dest_dir
    backup_file = File.join backup_file_dir, File.basename(src_file)
    siba_file.file_utils_compare_file(src_file, backup_file).must_equal true

    Siba::FileHelper.dirs_count(dest_dir).must_equal 2, "Should create two folders for each source"
  end
  
  it "backup should log error message if one of the sources is not found" do
    src_dir = prepare_test_dir "s-f-src-dir"
    f = @files.new ["/non-existing-file", src_dir],[],true

    dest_dir = mkdir_in_tmp_dir "s-f-dest-dir"
    f.backup dest_dir

    # The existing dir must be copied 
    backup_dir = @files.sub_dir_name 2, 1, false, File.basename(src_dir), dest_dir
    dirs_same? src_dir, backup_dir

    Siba::FileHelper.dirs_count(dest_dir).must_equal 1, "Only valid source must be copies"
    must_log "error"
  end

  it "backup should NOT copy if ignored" do
    src_dir = prepare_test_dir "s-f-src-dir"
    src_file = prepare_test_file "s-f-src-file"
    f = @files.new [src_dir, src_file],["*"],true
    dest_dir = mkdir_in_tmp_dir "s-f-dest-dir"
    f.backup dest_dir
    Siba::FileHelper.dir_empty?(dest_dir).must_equal true
  end
end
