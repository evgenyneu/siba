# encoding: UTF-8

require 'helper/require_unit'
require 'siba/plugins/archive/tar/init'

describe Siba::Archive::Tar::Init do
  before do    
    @yml_path = File.expand_path('../yml/init', __FILE__)
    @plugin_name="archive"
    @plugin_type="tar"
  end

  it "should load" do
    archive = create_plugin("valid")
    archive.archive.compression.must_be_instance_of String
  end

  it "init should raise error if compression is incorrect" do
    ->{create_plugin("invalid_compression")}.must_raise Siba::CheckError
  end

  it "init should use default compression if undefined in options" do
    archive = create_plugin("default_compression")
    archive.archive.compression.must_equal Siba::Archive::Tar::DefaultCompression
  end

  it "should run backup" do
    archive = create_plugin("valid")
    archive.backup("/src-dir", "/dst-dir", "file_name").must_be_instance_of String
  end
end
