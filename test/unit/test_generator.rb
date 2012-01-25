# encoding: UTF-8

require 'helper/require_unit'

describe Siba::Generator do
  before do
    @obj = Siba::Generator.new("file")
  end

  it "should call generate" do
    @obj.generate
  end

  it "should call get_plugin_yaml_path" do
    Siba::Generator.get_plugin_yaml_path "source", "files"
  end
  
  it "should call load_plugin_yaml_content" do
    Siba::Generator.load_plugin_yaml_content "source", "files"
  end
end
