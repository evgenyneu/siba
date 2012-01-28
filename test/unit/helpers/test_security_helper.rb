# encoding: UTF-8

require 'helper/require_unit' 

describe Siba::SecurityHelper do
  before do
    @sh = Siba::SecurityHelper
  end

  it "should generate password for yaml" do
    @sh.generate_password_for_yaml.length.must_equal 16
    @sh.generate_password_for_yaml(8).length.must_equal 8
  end

  it "should generate alphanumeric password" do
    @sh.alphanumeric_password.length.must_equal 16
    @sh.alphanumeric_password(9).length.must_equal 9
    @sh.alphanumeric_password(9, true)
    @sh.alphanumeric_password(9, true, true)
  end
end
