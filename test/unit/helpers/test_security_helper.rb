# encoding: UTF-8

require 'helper/require_unit' 

describe Siba::SecurityHelper do
  before do
    @sh = Siba::SecurityHelper
  end

  it "should generate password" do
    @sh.generate_password.length.must_equal 16
    @sh.generate_password(8).length.must_equal 8
  end
end
