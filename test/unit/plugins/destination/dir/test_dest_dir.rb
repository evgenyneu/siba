# encoding: UTF-8

require 'helper/require_unit'
require 'siba/plugins/destination/dir/init'

describe Siba::Destination::Dir::DestDir do
  before do    
    @dir = "/some-dir"
    @cls = Siba::Destination::Dir::DestDir
  end

  it "should init" do
    @cls.new @dir
  end

  it "should access dir" do
    dest_dir = @cls.new @dir
    dest_dir.dir = @dir
    dest_dir.dir.must_equal @dir
  end

  it "init should test access to destination dir" do
    dest_dir = @cls.new @dir
    dest_dir.test_dir_access
  end

  it "should call copy_backup_to_dest" do
    dest_dir = @cls.new @dir
    dest_dir.copy_backup_to_dest "/backup"
  end

  it "should call restore_backup_to_dir" do
    dest_dir = @cls.new @dir
    dest_dir.restore_backup_to_dir "name", "/backup"
  end

  it "should call get_backup_dir" do
    dest_dir = @cls.new @dir
    dest_dir.get_backups_list "my"
  end
end
