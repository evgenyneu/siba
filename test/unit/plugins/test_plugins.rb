# encoding: UTF-8

require 'helper/require_unit'

describe Siba::Plugins do
  before do
    @obj = Siba::Plugins
  end

  it "should get CATEGORIES" do
    @obj::CATEGORIES.must_be_instance_of Array
    @obj::CATEGORIES.must_include "source"
    @obj::CATEGORIES.must_include "archive"
    @obj::CATEGORIES.must_include "encryption"
    @obj::CATEGORIES.must_include "destination"
  end

  it "should call categories_str" do
    @obj.categories_str.wont_be_empty
  end

  it "should call get_list" do
    @obj.get_list.wont_be_empty
  end

  it "should call plugin_description" do
    @obj.plugin_description("destination", "dir").wont_be_empty
  end

  it "plugin_description should fail if uncorrect plugin name" do
    ->{@obj.plugin_description("destination", "unknown")}.must_raise Siba::Error
    ->{@obj.plugin_description("unknown", "dir")}.must_raise Siba::Error
  end

  it "should call plugin_type_and_description" do
    @obj.plugin_type_and_description("destination", "dir", 20).wont_be_empty
  end
end
