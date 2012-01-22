# encoding: UTF-8

require 'helper/require_unit'
require 'siba/plugins/destination/dir/init'

describe Siba::Destination::Dir::DestDir do
  before do    
    @dir = "/some-dir"
  end

  it "should init" do
    Siba::Destination::Dir::DestDir.new @dir
  end

  it "should access dir" do
    dest_dir = Siba::Destination::Dir::DestDir.new @dir
    dest_dir.dir = @dir
    dest_dir.dir.must_equal @dir
  end

  it "init should test access to destination dir" do
    dest_dir = Siba::Destination::Dir::DestDir.new @dir
    dest_dir.test_dir_access
  end

  it "should call copy_backup_to_dest" do
    dest_dir = Siba::Destination::Dir::DestDir.new @dir
    dest_dir.copy_backup_to_dest "/backup"
  end
end
