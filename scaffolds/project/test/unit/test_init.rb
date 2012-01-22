# encoding: UTF-8

require 'helper/require_unit'
require 'siba-c6y-demo/init'

describe Siba::C6y::Demo do
  before do                    
    @yml_path = File.expand_path('../yml', __FILE__)
    @plugin_category = "c6y"     
    @plugin_type = "demo"         
  end

  it "siba should load plugin" do
    plugin = create_plugin "valid"
    plugin.must_be_instance_of Siba::C6y::Demo::Init
  end
end
