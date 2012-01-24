# encoding: UTF-8

require 'helper/require_integration'

describe Siba::Generator do
  before do
  end

  it "should create generator" do
    test_file = prepare_test_file "gen"
    @obj = Siba::Generator.new test_file
    @obj.generate
  end
end
