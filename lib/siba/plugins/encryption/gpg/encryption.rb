# encoding: UTF-8

module Siba::Encryption
  module Gpg
    class Encryption 
      include Siba::LoggerPlug
      include Siba::FilePlug

      DEFAULT_CIPHER = "AES256"      

      attr_accessor :passphrase, :cipher

      def initialize(passphrase, cipher=DEFAULT_CIPHER)
        @passphrase = passphrase
        @cipher = Encryption.check_cipher cipher
        check_password_strength
        test_encryption
      end

      def encrypt(path_to_archive)
        path_to_encrypted_backup = "#{path_to_archive}.gpg"
        siba_file.run_this("encrypt") do
          if siba_file.file_file? path_to_encrypted_backup
            raise Siba::Error, "Encrypted file #{path_to_encrypted_backup} already exists" 
          end
          passphare_for_command = passphrase.gsub('"','\\"')
          gpg_homedir = Siba::TestFiles.mkdir_in_tmp_dir "gpg-homedir"
          command_without_password = %(gpg -c -q --batch --homedir="#{gpg_homedir}" --no-options --cipher-algo=#{cipher} --passphrase="****" --no-use-agent "#{path_to_archive}")
          command = command_without_password.gsub "****", passphare_for_command
          siba_file.run_shell command, "failed to encrypt: #{command_without_password}"
          unless siba_file.file_file? path_to_encrypted_backup
            raise siba::error, "failed to find encrypted backup file: #{command_without_password}" 
          end
        end
        path_to_encrypted_backup 
      end

      def decrypt(path_to_encrypted_file, path_to_decrypted_file=nil)
        path_to_decrypted_file = path_to_encrypted_file.gsub /\.gpg$/, "" if path_to_decrypted_file.nil?
        siba_file.run_this("decrypt") do
          if siba_file.file_file? path_to_decrypted_file
            raise Siba::Error, "Decrypted file #{path_to_decrypted_file} already exists" 
          end
          passphare_for_command = passphrase.gsub('"','\\"')
          gpg_homedir = Siba::TestFiles.mkdir_in_tmp_dir "gpg-homedir"
          command_without_password = %(gpg -d -q --batch --homedir="#{gpg_homedir}" --no-options --passphrase="****" -o "#{path_to_decrypted_file}" --no-use-agent "#{path_to_encrypted_file}")
          command = command_without_password.gsub "****", passphare_for_command
          siba_file.run_shell command, "failed to decrypt: #{command_without_password}"
          unless siba_file.file_file? path_to_decrypted_file
            raise siba::error, "failed to find decrypted backup file: #{command_without_password}" 
          end
        end
        path_to_decrypted_file
      end

      def test_encryption
        begin
          siba_file.run_this("test_encryption") do
            # encrypt
            path_to_source_file = Siba::TestFiles.prepare_test_file "encryption-gpg"
            path_to_encrypted_file = encrypt path_to_source_file
            raise unless path_to_encrypted_file == "#{path_to_source_file}.gpg"
            raise unless siba_file.file_file? path_to_encrypted_file
            raise if siba_file.file_utils_compare_file path_to_source_file, path_to_encrypted_file

            # decrypt
            path_to_output_file = "#{path_to_source_file}.decrypted"
            path_to_decrypted_file = decrypt path_to_encrypted_file, path_to_output_file
            raise unless path_to_decrypted_file == path_to_output_file
            raise unless siba_file.file_utils_compare_file path_to_source_file, path_to_decrypted_file

            logger.debug "GPG encryption is verified"
          end
        rescue Exception
          logger.error "'gpg' encryption utility does not work correctly. Try reinstalling it."
          raise
        end
      end

      class << self
        include Siba::FilePlug
        include Siba::LoggerPlug

        def check_cipher(cipher)
          siba_file.run_this("check_cipher") do
            supported_ciphers = nil
            begin
              supported_ciphers = Encryption.get_cipher_names
            rescue Exception
              logger.error "'gpg' encryption utility is not found. Please install it."
              raise
            end

            supported_ciphers_msg = "Please use one of the following: #{supported_ciphers.join(', ')}."
            if cipher.nil?
              cipher = Encryption::DEFAULT_CIPHER
              raise Siba::CheckError, "Default cipher '#{cipher}' is not supported.
#{supported_ciphers_msg}" unless supported_ciphers.include?(cipher)
            else
              cipher.upcase!
            end
            
            raise Siba::CheckError, "'#{cipher}' cipher is not supported.
#{supported_ciphers_msg}" unless supported_ciphers.include?(cipher)
          end
          cipher
        end

        def get_cipher_names          
          output = siba_file.run_shell "gpg --version"
          cipher_names = parse_cipher_names output
          raise Siba::Error, "Failed to get the list of supported ciphers" if cipher_names.empty?
          cipher_names
        end

        def parse_cipher_names(version)
          scan = version.scan /Cipher:(.*?)\n\w+:/m
          scan = version.scan /Cipher:(.*)/m if scan.size == 0
          if scan.size == 0 || !scan[0].is_a?(Array) || scan[0].size == 0 || !scan[0][0].is_a?(String)
            raise "Failed to parse gpg version information" 
          end
          scan = scan[0][0]
          scan.gsub!(/ |\n/, "")
          scan.split(",").each {|a| a.upcase!}
        end
      end

      private

      def check_password_strength
        seconds_to_crack = Siba::PasswordStrength.seconds_to_crack(@passphrase)
        if Siba::PasswordStrength.is_weak? seconds_to_crack
          timespan_to_guess = Siba::PasswordStrength.seconds_to_timespan seconds_to_crack
          guess_estimation_message = "It will take #{timespan_to_guess} to guess it."
          logger.warn "Your encryption password is weak. #{guess_estimation_message}"
        end
      end
    end
  end
end
