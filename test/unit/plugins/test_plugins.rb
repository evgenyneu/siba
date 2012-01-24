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
end
