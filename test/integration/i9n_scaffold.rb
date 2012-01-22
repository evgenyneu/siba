# encoding: UTF-8

require 'helper/require_integration'

describe Siba::Scaffold do
  before do
    @obj = Siba::Scaffold.new "destination", "myname"
  end

  it "should run scaffold" do
    dest_dir = mkdir_in_tmp_dir "scf-d"
    Siba::FileHelper.dir_empty?(dest_dir).must_equal true
    @obj.scaffold dest_dir
    Siba::FileHelper.dir_empty?(dest_dir).must_equal false
  end
end

