# encoding: UTF-8

require 'helper/require_integration'

describe Siba::TmpDir do
  before do
    @tmp_dir = Siba::TmpDir.new
  end

  after do
    @tmp_dir.cleanup unless @tmp_dir.nil?
  end

  it "should get tmp dir" do
    siba_file.file_directory?(@tmp_dir.get).must_equal true
  end

  it "should get the same tmp on second call" do
    dir1 = @tmp_dir.get
    dir2 = @tmp_dir.get
    dir1.must_equal dir2
  end

  it "should use dir specified in settings" do
    test_dir = prepare_test_dir "tmp-dir"
    Siba.settings = {"tmp_dir"=>test_dir}
    dir1 = @tmp_dir.get
    dir1.must_match /^#{test_dir}/
  end

  it "should cleanup" do
    dir = @tmp_dir.get
    @tmp_dir.cleanup
    siba_file.file_directory?(dir).must_equal false
  end

  it "should cleanup without calling get" do
    @tmp_dir.cleanup
  end

  it "should call test_access" do
    Siba::TmpDir.test_access
  end
end
