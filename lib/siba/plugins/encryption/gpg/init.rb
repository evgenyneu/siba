# encoding: UTF-8

require 'siba/helpers/password_strength'
require 'siba/plugins/encryption/gpg/encryption'

module Siba::Encryption
  module Gpg
    class Init
      include Siba::LoggerPlug
      attr_accessor :encryption

      def initialize(options)
        passphrase = Siba::SibaCheck.options_string(options, "passphrase")
        cipher = Siba::SibaCheck.options_string(options, "cipher", true)
        @encryption = Siba::Encryption::Gpg::Encryption.new passphrase, cipher
      end     

      def backup(path_to_archive)
        logger.info "Encrypting backup with 'gpg', cipher: '#{encryption.cipher}'"
        encryption.encrypt path_to_archive
      end
    end
  end
end
