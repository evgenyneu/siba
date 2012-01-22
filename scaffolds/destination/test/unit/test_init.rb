# encoding: UTF-8

require 'helper/require_unit'
require 'siba-destination-demo/init'

describe Siba::Destination::Demo do
  it "should load plugin" do
    plugin = create_plugin "valid"
    plugin.must_be_instance_of Siba::Destination::Demo::Init
  end
end
