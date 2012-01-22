# encoding: UTF-8

require 'helper/require_unit'
require 'siba/plugins/source/files/init'

describe Siba::Source::Files::Init do
  before do    
    @yml_path = File.expand_path('../yml', __FILE__)
    @plugin_category="source"
    @plugin_type="files"
  end

  it "should load" do
    create_plugin("valid").files.ignore.must_be_instance_of Array
  end

  it "load should fail no include" do
    -> {create_plugin("no_include")}.must_raise Siba::CheckError
  end

  it "load should fail include is not array" do
    -> {create_plugin("include_not_array")}.must_raise Siba::CheckError
  end

  it "should load ignore list" do
    create_plugin("valid").files.ignore.must_be_instance_of Array
  end
  
  it "load should fail ignore is not array" do
    -> {create_plugin("ignore_not_array")}.must_raise Siba::CheckError
  end

  it "should load include_subdirs=true when it is missing in options" do
    create_plugin("include_subdirs_missing").files.include_subdirs.must_equal true
  end

  it "should load include_subdirs=false" do
    create_plugin("include_subdirs_false").files.include_subdirs.must_equal false
  end
  
  it "backup should copy file" do
    create_plugin("valid").backup "dir"
  end
end
