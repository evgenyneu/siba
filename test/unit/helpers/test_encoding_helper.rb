# encoding: UTF-8

require 'helper/require_unit'

describe Siba::EncodingHelper do
  before do
    @str_arg = "str"
    @array_arg = ["str1","str2",nil]
    @result = "result"
  end

  it "should run encode_to_external" do
    str = Siba::EncodingHelper.encode_to_external @str_arg
    str.must_equal @str_arg
    str.encoding.must_equal Siba::EncodingHelper::EXTERNAL_ENCODING
  end
end
