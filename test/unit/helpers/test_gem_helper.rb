# encoding: UTF-8

require 'helper/require_unit'

describe Siba::GemHelper do
  before do
    @cls = Siba::GemHelper
  end

  it "should call all_local_gems" do
    @cls.all_local_gems[0].must_be_instance_of Gem::Specification
  end

  it "should call gem_path" do
    @cls.gem_path("rake").must_be_instance_of String
  end
end
