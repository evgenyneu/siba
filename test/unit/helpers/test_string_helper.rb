# encoding: UTF-8

require 'helper/require_unit' 

describe Siba::StringHelper do
  before do
    @sh = Siba::StringHelper
  end

  it "must call str_to_alphnumeric" do
    @sh.str_to_alphnumeric("Hello world").must_equal "hello-world"
    @sh.str_to_alphnumeric(" hello ").must_equal "hello"
    @sh.str_to_alphnumeric('hello`~!@#$%^&*()":<>?/-=[]{}world').must_equal "hello-world"
    @sh.str_to_alphnumeric('one . two    three').must_equal "one-two-three"
    @sh.str_to_alphnumeric('one#$%').must_equal "one"
    @sh.str_to_alphnumeric('#$%').must_equal ""
  end

  it "must camelize" do
    @sh.camelize("test").must_equal "Test"
    @sh.camelize("another_test_str").must_equal "AnotherTestStr"
    @sh.camelize("another-test-str").must_equal "AnotherTestStr"
  end

  it "should call escape_for_yaml" do
    str = 'test\one"two'
    value = @sh.escape_for_yaml(str)
    reloaded = YAML.load("key: \"#{value}\"")
    reloaded["key"].must_equal str
  end
end
