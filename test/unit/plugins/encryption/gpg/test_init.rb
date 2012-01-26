# encoding: UTF-8

require 'helper/require_unit'
require 'siba/plugins/encryption/gpg/init'

describe Siba::Encryption::Gpg::Init do
  before do
    @plugin_category="encryption"
    @plugin_type="gpg"
    @options = {'passphrase' => "my pass word", "cipher" => "AES256"}
  end

  it "must init plugin" do
    plugin = create_plugin(@options)
    plugin.encryption.wont_be_nil
    plugin.encryption.passphrase.wont_be_nil
    plugin.encryption.cipher.wont_be_nil
    plugin.encryption.passphrase.must_equal @options["passphrase"] 
    plugin.encryption.cipher.must_equal @options["cipher"] 
  end

  it "must init with missing" do
    plugin = create_plugin({'passphrase'=>'pass'})
    plugin.encryption.cipher.must_be_nil
  end

  it "must init with numeric passphrase" do
    plugin = create_plugin({'passphrase'=>123})
    plugin.encryption.passphrase.must_equal "123"
  end

  it "init must fail if empty passphrase" do
    ->{create_plugin({'passphrase' => nil})}.must_raise Siba::CheckError
    ->{create_plugin({'passphrase' => ""})}.must_raise Siba::CheckError
    ->{create_plugin({'passphrase' => " "})}.must_raise Siba::CheckError
  end
  
  it "must call backup" do
    plugin = create_plugin(@options)
    plugin.backup("/path/to/archive", "/dest_dir").must_be_instance_of String
  end
end
