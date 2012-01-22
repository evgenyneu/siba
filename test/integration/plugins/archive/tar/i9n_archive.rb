# encoding: UTF-8

require 'helper/require_integration'
require 'siba/plugins/archive/tar/init'

describe Siba::Archive::Tar::Archive do
  it "should init with no compression" do
    Siba::Archive::Tar::Archive.new "none"
  end

  it "should init with gzip" do
    Siba::Archive::Tar::Archive.new "gzip"
  end

  it "should init with bzip2" do
    Siba::Archive::Tar::Archive.new "bzip2"
  end
end
