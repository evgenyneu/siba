# encoding: UTF-8

require 'helper/require_unit'

describe Siba::Plugin do
  before do
    @obj = Siba::Plugin
  end
  it "should get CATEGORIES" do
    @obj::CATEGORIES.is_a? Array
    @obj::CATEGORIES.include? "source"
  end

  it "should call categories_str" do
    @obj.categories_str.wont_be_empty
  end
end
