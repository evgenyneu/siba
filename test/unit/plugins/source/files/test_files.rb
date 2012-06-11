# encoding: UTF-8

require 'helper/require_unit'
require 'siba/plugins/source/files/init'

describe Siba::Source::Files::Files do
  before do
    @f = Siba::Source::Files::Files
  end
  it "ignored? must NOT log if no files are excluded" do
    @f.new([], [], true).ignored?("/.hidden")
    wont_log "info"
  end

  it "ignored? must log if files are excluded" do
    @f.new([], ["*"], true).ignored?("/.hidden")
    must_log "info"
  end

  it "should call backup" do
    @f.new([], [], true).backup "/dest-dir"
  end

  it "should call copy_file" do
    @f.new([], [], true).copy_file "/src", "/dst"
  end

  it "should call copy_dir" do
    @f.new([], [], true).copy_dir "/src", "/dst", true
  end

  it "should call sub_dir_name" do
    @f.sub_dir_name(1,  1, true, "/dir1/dir2/file","/root").must_equal "/root/1-file-file"
    @f.sub_dir_name(1,  2, false, "/dir1/dir2/file","/root").must_equal "/root/01-dir-file"
    @f.sub_dir_name(23, 1, false, "/dir1/dir2/file","/root").must_equal "/root/23-dir-file"
    @f.sub_dir_name(12, 3, true, "/dir1/dir2/file","/root").must_equal "/root/012-file-file"
    @f.sub_dir_name(5,  3, true, "/dir1/dir2/file","/root").must_equal "/root/005-file-file"
    @f.sub_dir_name(3,  2, false, "/","/root").must_equal "/root/03-dir-root"
  end

  it "should call restore" do
    @f.new([], [], true).restore "/from-dir"
  end
end
