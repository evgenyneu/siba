# encoding: UTF-8

require 'helper/require_unit'
require 'siba/plugins/archive/tar/init'

describe Siba::Archive::Tar::Init do
  before do    
    @yml_path = File.expand_path('../yml/archive', __FILE__)
  end

  it "should create archive and run check_installed" do
    fmock = mock_file :run_this, true, ["test installed"]
    archive = Siba::Archive::Tar::Archive.new "gzip"
    fmock.verify
  end

  it "should run archive" do
    archive = Siba::Archive::Tar::Archive.new "gzip"
    file_name = "file"
    dest_dir = "/dir"

    Siba::Archive::Tar::Archive.new("none")
      .archive("",dest_dir,file_name)
      .must_match /#{dest_dir}\/#{file_name}\.tar$/

    Siba::Archive::Tar::Archive.new("gzip")
      .archive("",dest_dir,file_name)
      .must_match /#{dest_dir}\/#{file_name}\.tar.gz$/
        
    Siba::Archive::Tar::Archive.new("bzip2")
      .archive("",dest_dir,file_name)
      .must_match /#{dest_dir}\/#{file_name}\.tar.bz2$/
  end

  it "backup should fail" do
    ->{Siba::Archive::Tar::Archive.new("incorrect").archive("","","")}.must_raise Siba::CheckError
  end
end
