# encoding: UTF-8

require 'helper/require_integration'

describe Siba::InstalledPlugins do
  before do
    @cls = Siba::InstalledPlugins
  end

  it "should return plugin path" do
    File.directory?(@cls.plugin_path("source", "files")).must_equal true
  end
end
