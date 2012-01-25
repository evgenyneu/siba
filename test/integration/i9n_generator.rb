# encoding: UTF-8

require 'helper/require_integration'

describe Siba::Generator do
  before do
    SibaTest::KernelMock.gets_return_value = "1"
  end

  it "should create generator" do
    test_file = generate_path "gen"
    @obj = Siba::Generator.new test_file
    path_to_yml = @obj.generate
    Siba::FileHelper.read(path_to_yml).wont_be_empty
  end

  it "generator should fail if file exists" do
    path = generate_path "gen"
    path = "#{path}.yml"
    FileUtils.touch path
    File.file?(path).must_equal true
    @obj = Siba::Generator.new path
    ->{@obj.generate}.must_raise Siba::Error
  end

  it "should call get_plugin_yaml_path" do
    Siba::Generator.get_plugin_yaml_path("source", "files").wont_be_empty
  end
end
