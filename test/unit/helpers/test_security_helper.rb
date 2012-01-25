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
end
