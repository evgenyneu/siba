# encoding: UTF-8

require 'helper/require_unit'

describe Siba::LogMessage do
  before do
    @loader = Siba::PluginLoader.loader
    @options = {"type"=>"tar"}
  end

  it "should load plugin" do
    @loader.load "archive", "tar", @options
  end

  it "should fail when plugin name is incorrect" do
    begin
      @loader.load "source", "incorrect", @options
    rescue Siba::PluginLoadError => e
      e.message.must_match /\AUnknown type 'incorrect'/
    end
  end

  it "should fail when plugin name is not installed" do
    old_plugins_hash = Siba::Plugins::PLUGINS_HASH
    SibaTest::RemovableConstants.redef_without_warning Siba::Plugins,
      "PLUGINS_HASH", { "missing" => { "gem" => "description" } }

    old_categories = Siba::Plugins::CATEGORIES
    SibaTest::RemovableConstants.redef_without_warning Siba::Plugins,
      "CATEGORIES", ["missing"]

    begin
      @loader.load "missing", "gem", @options
    rescue Siba::PluginLoadError => e
      e.message.must_match /\A'gem' plugin is not installed/
    end

    SibaTest::RemovableConstants.redef_without_warning Siba::Plugins, "PLUGINS_HASH", old_plugins_hash
    SibaTest::RemovableConstants.redef_without_warning Siba::Plugins, "CATEGORIES", old_categories
  end

  it "should fail when plugin type is unknown" do
    ->{@loader.load "archive", "incorrect", @options}.must_raise Siba::PluginLoadError
  end

  it "should fail when options are incorrect" do
    ->{@loader.load "archive", "tar", "incorrect options"}.must_raise Siba::PluginLoadError
  end
end
