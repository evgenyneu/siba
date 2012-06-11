# encoding: UTF-8

require 'helper/require_integration'
require 'siba/plugins/encryption/gpg/init'

describe Siba::Encryption::Gpg::Encryption do
  before do
    @passphrase = Siba::SecurityHelper.generate_password_for_yaml
  end

  it "init should fail if cipher is not supported" do
    ->{Siba::Encryption::Gpg::Encryption.new @passphrase, "unknown_cipher"}.must_raise Siba::CheckError
  end

  it "init should assign default cipher if it's not supplied" do
    encryption = Siba::Encryption::Gpg::Encryption.new @passphrase
    encryption.cipher.wont_be_nil
  end

  it "should encrypt and decrypt" do
    encryption = Siba::Encryption::Gpg::Encryption.new @passphrase
    path_to_source_file = prepare_test_file "encryption-gpg-1"
    path_to_encrypted_file = encryption.encrypt path_to_source_file
    path_to_encrypted_file.must_equal "#{path_to_source_file}.gpg"
    siba_file.file_file?(path_to_encrypted_file).must_equal true
    siba_file.file_utils_compare_file(path_to_source_file, path_to_encrypted_file).must_equal false

    # decrypt
    path_to_output_file = "#{path_to_source_file}.decrypted"
    path_to_decrypted_file = encryption.decrypt path_to_encrypted_file, path_to_output_file
    path_to_decrypted_file.must_equal path_to_output_file
    siba_file.file_utils_compare_file(path_to_source_file, path_to_decrypted_file).must_equal true


    # decrypt without output file parameter
    ->{encryption.decrypt path_to_encrypted_file}.must_raise Siba::Error, "Should fail to decrypt if file already exists"
    FileUtils.mv path_to_source_file, path_to_source_file + "new"
    path_to_decrypted_file = encryption.decrypt path_to_encrypted_file
    path_to_decrypted_file.must_equal path_to_source_file

    # should fail to decrypt with incorrect passphrase
    encryption.passphrase = "incorrect"
    ->{encryption.decrypt path_to_encrypted_file}.must_raise Siba::Error
  end

  it "should raise error if encrypted file exists" do
    encryption = Siba::Encryption::Gpg::Encryption.new @passphrase
    path_to_source_file = prepare_test_file "encyptor-gpg-exists"
    path_to_encrypted_file = path_to_source_file + ".gpg"
    siba_file.file_utils_touch path_to_encrypted_file
    ->{encryption.encrypt path_to_source_file}.must_raise Siba::Error
  end

  it "should get cipher names" do
    names = Siba::Encryption::Gpg::Encryption.get_cipher_names
    names.must_be_instance_of Array
    names.wont_be_empty
    names[0].must_equal names[0].upcase
  end

  it "must call check_cipher" do
    names = Siba::Encryption::Gpg::Encryption.get_cipher_names
    cipher = names.sample.upcase
    Siba::Encryption::Gpg::Encryption.check_cipher(cipher).must_equal(cipher.upcase)

    cipher = names.sample.downcase
    Siba::Encryption::Gpg::Encryption.check_cipher(cipher).must_equal(cipher.upcase)
  end

  it "check_cipher must return default cipher if none is supplied" do
    names = Siba::Encryption::Gpg::Encryption.get_cipher_names
    default = Siba::Encryption::Gpg::Encryption.check_cipher(nil)
    names.must_include default
  end

  it "check_cipher must raise error if default cipher is not supported" do
    old_cipher = Siba::Encryption::Gpg::Encryption::DEFAULT_CIPHER
    SibaTest::RemovableConstants.redef_without_warning Siba::Encryption::Gpg::Encryption, "DEFAULT_CIPHER", "NEW_CIPHER"
    names = Siba::Encryption::Gpg::Encryption.get_cipher_names
    ->{Siba::Encryption::Gpg::Encryption.check_cipher(nil)}.must_raise Siba::CheckError
    SibaTest::RemovableConstants.redef_without_warning Siba::Encryption::Gpg::Encryption, "DEFAULT_CIPHER", old_cipher
  end

  it "check_cipher must fail if unknown cipher is used" do
    ->{Siba::Encryption::Gpg::Encryption.check_cipher("incorrect")}.must_raise Siba::CheckError
  end
end
