# encoding: UTF-8

require 'siba/helpers/password_strength'
require 'siba/plugins/encryption/gpg/encryption'

module Siba::Encryption
  module Gpg
    class Init
      include Siba::LoggerPlug
      include Siba::FilePlug
      attr_accessor :encryption

      def initialize(options)
        passphrase = Siba::SibaCheck.options_string(options, "passphrase")
        cipher = Siba::SibaCheck.options_string(options, "cipher", true)
        @encryption = Siba::Encryption::Gpg::Encryption.new passphrase, cipher
      end     

      # Returns the name of encrypted file
      def backup(path_to_archive, dest_dir)
        logger.info "Encrypting backup with 'gpg', cipher: '#{encryption.cipher}'"
        path_to_encrypted_file = encryption.encrypt path_to_archive

        # move encrypted file to dest_dir
        file_name = File.basename path_to_encrypted_file
        dest_file_path = File.join dest_dir, file_name
        siba_file.file_utils_mv path_to_encrypted_file, dest_file_path
        file_name
      end

      # Decrypt path_to_backup to_dir
      def restore(path_to_backup, to_dir)
        logger.info "Decrypting backup with 'gpg', cipher: '#{encryption.cipher}'"
        decrypted_file_name = File.basename path_to_backup
        decrypted_file_name.gsub! /\.gpg$/, ""
        path_to_decrypted_file = File.join to_dir, decrypted_file_name
        encryption.decrypt path_to_backup, path_to_decrypted_file
        decrypted_file_name
      end
    end
  end
end
