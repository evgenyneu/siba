# encoding: UTF-8

require 'helper/require_unit'
require 'siba-c6y-demo/init'

describe Siba::C6y::Demo do
  it "should load plugin" do
    plugin = create_plugin "valid"
    plugin.must_be_instance_of Siba::C6y::Demo::Init
  end
end
