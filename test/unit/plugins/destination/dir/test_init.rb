# encoding: UTF-8

require 'helper/require_unit'
require 'siba/plugins/destination/dir/init'

describe Siba::Destination::Dir::Init do
  before do    
    @yml_path = File.expand_path('../yml/init', __FILE__)
    @plugin_category="destination"
    @plugin_type="dir"
  end

  it "should load" do
    plugin = create_plugin("valid")
    plugin.dest_dir.must_be_instance_of Siba::Destination::Dir::DestDir
  end

  it "load should fail when dir is missing" do
    ->{create_plugin({})}.must_raise Siba::CheckError
    ->{create_plugin({"dir" => nil})}.must_raise Siba::CheckError
    ->{create_plugin({"dir" => ""})}.must_raise Siba::CheckError
    ->{create_plugin({"dir" => " "})}.must_raise Siba::CheckError
  end
end
