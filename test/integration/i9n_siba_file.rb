# encoding: UTF-8

require 'helper/require_integration'

describe Siba::Backup do
  before do
    @siba_file = Siba::SibaFile.new
  end

  it "should fail if incorrect" do
    ->{@siba_file.unknown}.must_raise NoMethodError
    ->{@siba_file.file_unknown}.must_raise NoMethodError
  end

  it "should run file_expand_path" do
    dirname = "dir/ep"
    one = @siba_file.file_expand_path(dirname)
    two = @siba_file.file_expand_path(dirname)
    three = @siba_file.file_expand_path(dirname)
    one.must_equal File.expand_path(dirname), "Should show absolute path"
    two.must_equal File.expand_path(dirname), "Should show absolute path"
    three.must_equal File.expand_path(dirname), "Should show absolute path"
    @siba_file.file_expand_path("~/#{dirname}").must_equal File.expand_path("~/#{dirname}"), "Path relative to home folder"
    tmp_dir = mkdir_in_tmp_dir "f-e-p"
    Siba.current_dir = tmp_dir
    tmp_dir2 = mkdir_in_tmp_dir "f-e-p2"
    siba_file.file_utils_cd tmp_dir2
    @siba_file.file_expand_path("#{dirname}").must_equal File.join(tmp_dir,dirname), "Path relative to Siba.current_dir"
  end
end
