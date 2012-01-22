# encoding: UTF-8

require 'helper/require_unit'

describe Siba do
  it "should access settings" do
    Siba.settings
  end
  
  it "should get tmp_dir" do
    Siba.tmp_dir.must_equal SibaTest::TmpDirMocked
  end

  it "should cleanup tmp dir" do
    Siba.tmp_dir
    Siba.cleanup_tmp_dir
  end

  it "should call cleanup" do
    Siba::LoggerPlug.opened?.must_equal true
    Siba.tmp_dir_clean?.must_equal false
    Siba.cleanup
    Siba::LoggerPlug.opened?.must_equal false
    Siba.tmp_dir_clean?.must_equal true
  end

  it "should get current_dir" do
    Siba.current_dir.wont_be_nil
  end

  it "should get settings" do
    Siba.settings.wont_be_nil
  end
end
