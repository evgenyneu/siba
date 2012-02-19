# encoding: UTF-8

require 'helper/require_unit'

describe Siba::SibaCheck do
  before do
    @cls = Siba::SibaCheck
  end

  it "should call options_string_array" do
    obj = {"name"=>["1","2"]}
    @cls.options_string_array(obj, "name", false).must_equal obj["name"]
  end

  it "options_string_array should raise if option is not defined" do
    ->{@cls.options_string_array({"name"=>["1","2"]}, "not exist")}.must_raise Siba::CheckError
  end

  it "options_string_array should return detaul value" do
    default = ["default"]
    @cls.options_string_array({"name"=>["1","2"]}, "not exist", true, default).must_equal default
  end

  it "options_string_array should accept a string" do
    obj = {"name"=>"just a string"}
    @cls.options_string_array(obj, "name", false).must_equal [obj["name"]]
    @cls.options_string_array({"name"=>123}, "name", false).must_equal ["123"]
  end

  it "options_string_array should accept an array and convert values to strings" do
    @cls.options_string_array({"name"=>[1, 5.5, "hello"]}, "name", false)
      .must_equal ["1", "5.5", "hello"]
  end

  it "options_string_array should fail if contains a hash" do
    ->{@cls.options_string_array({"name"=>{}}, "name", false)}.must_raise Siba::CheckError
  end

  it "options_string_array should fail if it contains empty or nil values" do
    ->{@cls.options_string_array({"name"=>" "}, "name", false)}.must_raise Siba::CheckError
    ->{@cls.options_string_array({"name"=>nil}, "name", false)}.must_raise Siba::CheckError
    ->{@cls.options_string_array({"name"=>["1", " "]}, "name", false)}.must_raise Siba::CheckError
    ->{@cls.options_string_array({"name"=>["1", ""]}, "name", false)}.must_raise Siba::CheckError
    ->{@cls.options_string_array({"name"=>["1", nil]}, "name", false)}.must_raise Siba::CheckError
  end

  it "should call options_bool" do
    @cls.options_bool({"name"=>true},"name").must_equal true
    @cls.options_bool({"name"=>false},"name").must_equal false
  end

  it "options_bool should raise error" do
    ->{@cls.options_bool({"name"=>true},"missing")}.must_raise Siba::CheckError
    ->{@cls.options_bool({"name"=>"non bool"},"name")}.must_raise Siba::CheckError
  end

  it "options_bool should return default_value if missing" do
    @cls.options_bool({"name"=>true},"missing", true).must_equal false
    @cls.options_bool({"name"=>true},"missing", true, true).must_equal true
    @cls.options_bool({"name"=>true},"missing", true, false).must_equal false
  end

  it "should call options_hash" do
    hash = {"key"=>"value"}
    options = {"name" =>hash}
    @cls.options_hash(options,"name").must_equal hash
    @cls.options_hash(options,"missing", true).must_be_nil
    def_hash = {"one"=>"two"}
    @cls.options_hash(options,"missing", true, def_hash).must_equal def_hash
  end

  it "options_hash should raise error" do
    ->{@cls.options_hash({"name"=>true},"missing")}.must_raise Siba::CheckError
    ->{@cls.options_hash({"name"=>"non hash"},"name")}.must_raise Siba::CheckError
  end

  it "should call hash" do
    hash = {"key"=>"value"}
    @cls.hash(hash, "name").must_equal hash
    @cls.hash(nil, "name", true).must_be_nil
  end

  it "hash should raise errors" do
    ->{@cls.hash("non hash","name")}.must_raise Siba::CheckError
  end

  it "should call options_string" do
    @cls.options_string({"name"=>"value"},"name").must_equal "value"
    @cls.options_string({"name"=>123},"name").must_equal "123"
    @cls.options_string({"name"=>1000000000000000000000000000000},"name").must_equal "1000000000000000000000000000000"
    @cls.options_string({"name"=>123.12},"name").must_equal "123.12"
    @cls.options_string({"name"=>"value"},"missing", true, "default").must_equal "default"
    @cls.options_string({"name"=>"value"},"missing", true, nil).must_be_nil
  end

  it "options_string should fail if value is array or hash" do
    ->{@cls.options_string({"name"=>[1,2,3]},"name")}.must_raise Siba::CheckError
    ->{@cls.options_string({"name"=>{:name=>:value}},"name")}.must_raise Siba::CheckError
  end

  it "options_string should fail if value missing" do
    ->{@cls.options_string({"name"=>"value"},"missing")}.must_raise Siba::CheckError
    ->{@cls.options_string({"name"=>nil},"name")}.must_raise Siba::CheckError
    ->{@cls.options_string({"name"=>""},"name")}.must_raise Siba::CheckError
    ->{@cls.options_string({"name"=>" "},"name")}.must_raise Siba::CheckError
  end

  it "should call try_to_s" do
    @cls.try_to_s("str", "name").must_equal "str"
    @cls.try_to_s(22, "name").must_equal "22"
    @cls.try_to_s(11.12, "name").must_equal "11.12"
    @cls.try_to_s(10000000000000000000000000000000000, "name").must_equal "10000000000000000000000000000000000"
  end

  it "try_to_s should fail" do
    ->{@cls.try_to_s([1], "name")}.must_raise Siba::CheckError
    ->{@cls.try_to_s(" ", "name")}.must_raise Siba::CheckError
  end
end
