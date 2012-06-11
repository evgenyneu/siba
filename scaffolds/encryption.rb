# encoding: UTF-8

module Siba::C6y
  module Demo
    class Init
      include Siba::FilePlug
      include Siba::LoggerPlug

      def initialize(options)
## init_example.rb ##
      end

      # Encrypt backup archive file (path_to_archive) and put it to dest_dir.
      # Return the name of encrypted file. It must begin with archive name
      # and its ending must always be the same.
      def backup(path_to_archive, dest_dir)
## examples.rb ##
      end

      # Decrypt backup file (path_to_backup) to_dir.
      # Return the name of decrypted file.
      def restore(path_to_backup, to_dir)
      end
    end
  end
end
