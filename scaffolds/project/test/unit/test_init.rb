# encoding: UTF-8

require 'helper/require_unit'
require 'siba-c6y-demo/init'

describe Siba::C6y::Demo do
  before do                    
    @yml_path = File.expand_path('../yml', __FILE__)
    @plugin_category = "c6y"     
    @plugin_type = "demo"         

    # helper to load the plugin reading the setting from YAML
    @plugin = create_plugin "valid"     
  end

  it "siba should load plugin" do
    @plugin.must_be_instance_of Siba::C6y::Demo::Init
  end

  it "should run backup" do
    @plugin.backup "/backup_file"
  end

  it "should load settings" do
    # helper to load options from YAML in @yml_path dir
    options_hash = load_options "valid" 
  end

  it "should check log" do
    must_log "info"
    @plugin.backup "/backup_file"
    verify_log # must have "info" messages

    wont_log "warn"
    # some code...
    verify_log # must not have warn message
    
    wont_log_from "warn"
    # some code...
    verify_log # must not have warn, error and fatal messages

    # show_log prints the entire log
  end
end
