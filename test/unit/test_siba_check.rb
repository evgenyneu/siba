# encoding: UTF-8

require 'helper/require_unit'

describe Siba::SibaCheck do
  it "should call options_string_array" do
    obj = {"name"=>["1","2"]}
    Siba::SibaCheck.options_string_array(obj, "name", false).must_equal obj["name"]
  end

  it "options_string_array should raise if option is not defined" do
    ->{Siba::SibaCheck.options_string_array({"name"=>["1","2"]}, "not exist")}.must_raise Siba::CheckError
  end

  it "options_string_array should return detaul value" do
    default = ["default"]
    Siba::SibaCheck.options_string_array({"name"=>["1","2"]}, "not exist", true, default).must_equal default
  end

  it "options_string_array should accept a string" do
    obj = {"name"=>"just a string"}
    Siba::SibaCheck.options_string_array(obj, "name", false).must_equal [obj["name"]]
    Siba::SibaCheck.options_string_array({"name"=>123}, "name", false).must_equal ["123"]
  end

  it "options_string_array should accept an array and convert values to strings" do
    Siba::SibaCheck.options_string_array({"name"=>[1, 5.5, "hello"]}, "name", false)
      .must_equal ["1", "5.5", "hello"]
  end

  it "options_string_array should fail if contains a hash" do
    ->{Siba::SibaCheck.options_string_array({"name"=>{}}, "name", false)}.must_raise Siba::CheckError
  end

  it "options_string_array should fail if it contains empty or nil values" do
    ->{Siba::SibaCheck.options_string_array({"name"=>" "}, "name", false)}.must_raise Siba::CheckError
    ->{Siba::SibaCheck.options_string_array({"name"=>nil}, "name", false)}.must_raise Siba::CheckError
    ->{Siba::SibaCheck.options_string_array({"name"=>["1", " "]}, "name", false)}.must_raise Siba::CheckError
    ->{Siba::SibaCheck.options_string_array({"name"=>["1", nil]}, "name", false)}.must_raise Siba::CheckError
  end

  it "should call options_bool" do
    Siba::SibaCheck.options_bool({"name"=>true},"name").must_equal true
    Siba::SibaCheck.options_bool({"name"=>false},"name").must_equal false
  end

  it "options_bool should raise error" do
    ->{Siba::SibaCheck.options_bool({"name"=>true},"missing")}.must_raise Siba::CheckError
    ->{Siba::SibaCheck.options_bool({"name"=>"non bool"},"name")}.must_raise Siba::CheckError
  end

  it "options_bool should return default_value if missing" do
    Siba::SibaCheck.options_bool({"name"=>true},"missing", true).must_equal false
    Siba::SibaCheck.options_bool({"name"=>true},"missing", true, true).must_equal true
    Siba::SibaCheck.options_bool({"name"=>true},"missing", true, false).must_equal false
  end

  it "should call options_hash" do
    hash = {"key"=>"value"}
    options = {"name" =>hash}
    Siba::SibaCheck.options_hash(options,"name").must_equal hash
    Siba::SibaCheck.options_hash(options,"missing", true).must_be_nil
    def_hash = {"one"=>"two"}
    Siba::SibaCheck.options_hash(options,"missing", true, def_hash).must_equal def_hash
  end

  it "options_hash should raise error" do
    ->{Siba::SibaCheck.options_hash({"name"=>true},"missing")}.must_raise Siba::CheckError
    ->{Siba::SibaCheck.options_hash({"name"=>"non hash"},"name")}.must_raise Siba::CheckError
  end

  it "should call hash" do
    hash = {"key"=>"value"}
    Siba::SibaCheck.hash(hash, "name").must_equal hash
    Siba::SibaCheck.hash(nil, "name", true).must_be_nil
  end

  it "hash should raise errors" do
    ->{Siba::SibaCheck.hash("non hash","name")}.must_raise Siba::CheckError
  end

  it "should call options_string" do
    Siba::SibaCheck.options_string({"name"=>"value"},"name").must_equal "value"
    Siba::SibaCheck.options_string({"name"=>123},"name").must_equal "123"
    Siba::SibaCheck.options_string({"name"=>1000000000000000000000000000000},"name").must_equal "1000000000000000000000000000000"
    Siba::SibaCheck.options_string({"name"=>123.12},"name").must_equal "123.12"
    Siba::SibaCheck.options_string({"name"=>"value"},"missing", true, "default").must_equal "default"
    Siba::SibaCheck.options_string({"name"=>"value"},"missing", true, nil).must_be_nil
  end

  it "options_string should fail if value is array or hash" do
    ->{Siba::SibaCheck.options_string({"name"=>[1,2,3]},"name")}.must_raise Siba::CheckError
    ->{Siba::SibaCheck.options_string({"name"=>{:name=>:value}},"name")}.must_raise Siba::CheckError
  end

  it "options_string should fail if value missing" do
    ->{Siba::SibaCheck.options_string({"name"=>"value"},"missing")}.must_raise Siba::CheckError
    ->{Siba::SibaCheck.options_string({"name"=>nil},"name")}.must_raise Siba::CheckError
    ->{Siba::SibaCheck.options_string({"name"=>""},"name")}.must_raise Siba::CheckError
    ->{Siba::SibaCheck.options_string({"name"=>" "},"name")}.must_raise Siba::CheckError
  end
end
