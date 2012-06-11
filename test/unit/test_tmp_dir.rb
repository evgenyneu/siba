# encoding: UTF-8

require 'helper/require_unit'

describe Siba::TmpDir do
  before do
    @tmp_dir_obj = Siba::TmpDir.new
  end

  it "should call get" do
    @tmp_dir_obj.get
  end

  it "should  call test_access" do
    Siba::TmpDir.test_access
  end

  it "should call cleanup" do
    @tmp_dir_obj.cleanup
  end
end
