# encoding: UTF-8

require 'helper/require_integration'

describe Siba::Scaffold do
  before do
    @gem_name = "myname"
    @obj = Siba::Scaffold.new "destination", @gem_name 
  end

  it "should run scaffold" do
    Siba::LoggerPlug.close
    Siba::SibaLogger.quiet = true

    dest_dir = mkdir_in_tmp_dir "scf-d"
    Siba::FileHelper.dir_empty?(dest_dir).must_equal true
    @obj.scaffold dest_dir
    Siba::FileHelper.dir_empty?(dest_dir).must_equal false
    dest_dir = File.join dest_dir, @gem_name
    File.directory?(dest_dir).must_equal true
    Siba::FileHelper.dirs_count(dest_dir).must_be :>, 1
    git_dir = File.join dest_dir, ".git"
    File.directory?(git_dir).must_equal true, "Must create git repository"
    wont_log_from "warn"
  end
end

