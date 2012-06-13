#cagegory encoding: UTF-8

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

  it "should return plugin path" do
    @cls.plugin_path("source", "files")
  end

  it "plugin_path should fail is plugin is not installed" do
    ->{@cls.plugin_path("source", "unknown")}.must_raise Siba::Error
  end

  it "should get gem name" do
    @cls.gem_name("source", "files").must_be_instance_of String
  end

  it "should call install_gem_message" do
    @cls.install_gem_message("source", "files").must_be_instance_of String
  end

end
