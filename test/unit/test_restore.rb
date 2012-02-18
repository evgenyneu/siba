# encoding: UTF-8

require 'helper/require_unit' 

describe Siba::Restore do
  before do
    @yml_path = File.expand_path('../yml', __FILE__)
  end
  
  it "should call restore without loading source plugin" do
    Siba::LoggerPlug.close
    Siba::SibaLogger.quiet = true
    path_to_options_file = File.join @yml_path, "valid.yml"
    obj = Siba::Restore.new
    obj.restore path_to_options_file, false
    obj.current_source.must_equal false
    wont_log_from "warn"
    must_log_msg "Loading destination", "debug"
    wont_log_msg "Loading source", "debug"
    Siba.tmp_dir_clean?.must_equal true
  end

  it "should call restore with loading source plugin" do
    Siba::LoggerPlug.close
    Siba::SibaLogger.quiet = true
    path_to_options_file = File.join @yml_path, "valid.yml"
    obj = Siba::Restore.new
    obj.restore path_to_options_file, true
    obj.current_source.must_equal true
    wont_log_from "warn"
    must_log_msg "Loading destination", "debug"
    must_log_msg "Loading source", "debug"
    Siba.tmp_dir_clean?.must_equal true
  end
end
