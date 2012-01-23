# encoding: UTF-8

require 'helper/require_unit'
require 'siba/plugins/encryption/gpg/init'

describe Siba::Encryption::Gpg::Encryption do
  before do
    @passphrase = "aj(dJ6Hja2Jj$kjask"
  end

  it "init should call test_encryption" do
    fmock = mock_file :run_this, nil, ["test_encryption"]
    Siba::Encryption::Gpg::Encryption.new(@passphrase)
    fmock.verify
  end
  
  it "init should call check_cipher" do
    fmock = mock_file :run_this, nil, ["check_cipher"]
    Siba::Encryption::Gpg::Encryption.new(@passphrase)
    fmock.verify
  end

  it "must call encrypt" do
    encryption = Siba::Encryption::Gpg::Encryption.new(@passphrase)
    path_to_archive = "/path/to/archive.tar.gz"
    path_to_encrypted_file = encryption.encrypt(path_to_archive)
    path_to_encrypted_file.must_equal "#{path_to_archive}.gpg"
  end

  it "must call decrypt" do
    encryption = Siba::Encryption::Gpg::Encryption.new(@passphrase)
    path = "/path/to/archive.tar.gz"
    path_to_decrypted_file = encryption.decrypt(path + ".gpg")
    path_to_decrypted_file.must_equal path
  end
  
  it "must call decrypt with output file parameter" do
    encryption = Siba::Encryption::Gpg::Encryption.new(@passphrase)
    path = "/path/to/archive.tar.gz.gz"
    output = "/output.file"
    path_to_decrypted_file = encryption.decrypt(path + ".gpg", output)
    path_to_decrypted_file.must_equal output
  end

  it "parse_cipher_names must work" do
    parse_data = [
      ["text \n Cipher: a, b,\nc,d", ["A","B","C","D"]],
      ["text \n Cipher: a, b,\nc,d\nHash: a, b, c", ["A","B","C","D"]]
    ]
    parse_data.each do |a|
      Siba::Encryption::Gpg::Encryption.parse_cipher_names(a[0]).must_equal a[1]
    end
  end
    
  it "init must warn if the password is weak" do
    Siba::Encryption::Gpg::Encryption.new "passwordisweak"
    must_log "warn"
  end

  it "init must NOT warn if the password is strong" do
    Siba::Encryption::Gpg::Encryption.new "A4n90!1j$Ox*"
    wont_log "warn"
  end

  it "must call test_encryption" do
    encryption = Siba::Encryption::Gpg::Encryption.new(@passphrase)
    encryption.test_encryption
  end

end
