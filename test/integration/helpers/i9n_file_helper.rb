# encoding: UTF-8

require 'helper/require_integration'

describe Siba::FileHelper do
  before do
    @obj = Siba::FileHelper
  end

  it "should call dir_empty?" do
    test_dir = prepare_test_dir "dir-not-empty"
    @obj.dir_empty?(test_dir).must_equal false

    empty_test_dir = mkdir_in_tmp_dir "dir-empty"
    @obj.dir_empty?(empty_test_dir).must_equal true
  end

  it "should call entries" do
    test_dir = prepare_test_dir "dir-not-empty"
    entries_to_compare = siba_file.dir_entries(test_dir) - %w{ . .. }
    entries = @obj.entries test_dir
    entries.wont_be_empty
    entries.must_equal entries_to_compare
  end

  it "should call dirs_count" do
    test_dir = prepare_test_dir "dir-not-empty"
    dirs_count = @obj.dirs_count test_dir
    dirs_count.must_equal 2
  end

  it "should call dirs_same?" do
    test_dir1 = prepare_test_dir "dirs-same-1"
    test_dir2 = prepare_test_dir "dirs-same-2"
    @obj.dirs_same? test_dir1, test_dir2

    # add a file to one dir
    new_file1 = prepare_test_file "unexpected", test_dir2
    ->{@obj.dirs_same? test_dir1, test_dir2}.must_raise Siba::Error

    # add the file to the other dir
    siba_file.file_utils_cp new_file1, test_dir1
    new_file2 = File.join test_dir1, File.basename(new_file1)
    @obj.dirs_same? test_dir1, test_dir2

    # change a file in one dir
    siba_file.file_open(new_file2,"a") {|a| a.write("new text")}
    ->{@obj.dirs_same? test_dir1, test_dir2}.must_raise Siba::Error
  end
end
