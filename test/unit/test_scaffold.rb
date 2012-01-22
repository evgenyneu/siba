# encoding: UTF-8

require 'helper/require_unit'

describe Siba::Scaffold do
  before do
    @obj = Siba::Scaffold.new "source", "gem___Name*%@#"
  end

  it "should init category and name" do
    @obj.category.must_equal "source"
    @obj.name.must_equal "gem-name"
  end

  it "should fail to init if first name character is number" do
    ->{Siba::Scaffold.new "source", "2gem___Name*%@#"}.must_raise Siba::Error
  end

  it "should fail to init if invalid category" do
    ->{Siba::Scaffold.new "invalid", "name"}.must_raise Siba::Error
  end

  it "should call scaffold" do
    @obj.scaffold "/dest-dir"
  end
end
