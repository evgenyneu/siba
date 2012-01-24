# encoding: UTF-8

require 'helper/require_unit'

describe Siba::InstalledPlugins do
  before do
    @cls = Siba::InstalledPlugins
  end

  it "should call all_installed" do
    @cls.all_installed.must_be_instance_of Hash
    @cls.all_installed.wont_be_empty
  end

  it "should call installed?" do
    @cls.installed?("source", "files").must_equal true
    @cls.installed?("source", "unknown").must_equal false
  end
end
