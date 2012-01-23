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
    # helper to load the plugin reading the setting from YAML
    plugin = create_plugin "valid"     
    plugin.must_be_instance_of Siba::C6y::Demo::Init
  end

  it "should load settings" do
    # helper to load options from YAML in @yml_path dir
    options_hash = load_options "valid" 
  end

  it "should check log" do
    #must_log "info"
    #wont_log "warn"
    #wont_log_from "warn"
    #show_log 
  end
end
