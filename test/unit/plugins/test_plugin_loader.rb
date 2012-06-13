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

  it "should fail when plugin name is incorrect or note installed" do
    begin
      @loader.load "source", "incorrect", @options
    rescue Siba::PluginLoadError => e
      e.message.must_match /\A'incorrect' plugin is not installed/
    end
  end

  it "should fail when plugin type is unknown" do
    ->{@loader.load "archive", "incorrect", @options}.must_raise Siba::PluginLoadError
  end

  it "should fail when options are incorrect" do
    ->{@loader.load "archive", "tar", "incorrect options"}.must_raise Siba::PluginLoadError
  end
end
