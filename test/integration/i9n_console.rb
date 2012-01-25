# encoding: UTF-8

require 'helper/require_integration'

describe Siba::Console do
  before do
    @console = Siba::Console.new true
  end

  it "should call generate command" do
    SibaTest::KernelMock.gets_return_value = "1"
    path_to_yml = generate_path("gen") + ".yml"
    @console.parse ["generate", path_to_yml]
    Siba::FileHelper.read(path_to_yml).wont_be_empty
  end
end
