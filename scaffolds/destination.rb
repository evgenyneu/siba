# encoding: UTF-8

module Siba::C6y
  module Demo
    class Init
      include Siba::FilePlug
      include Siba::LoggerPlug

      def initialize(options)
## init_example.rb ##
      end

      # Put backup file (path_to_backup_file) to destination
      # No return value is expected
      def backup(path_to_backup_file)
## examples.rb ##
      end

      # Shows the list of backup files stored currently at destination
      # with names starting with 'backup_name'
      #
      # Returns an array of two-element arrays:
      # [backup_file_name, modification_time]
      def get_backups_list(backup_name)
      end

      # Restoring: put backup file from destination into dir
      def restore(backup_name, dir)
      end
    end
  end
end
