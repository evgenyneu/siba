# encoding: UTF-8

require 'helper/require_integration'

describe Siba::Console do
  before do
    @console = Siba::Console.new true
  end

  it "should run generate" do
    test_file = prepare_test_file "gen"
    @console.parse ["generate", test_file]
  end
end
