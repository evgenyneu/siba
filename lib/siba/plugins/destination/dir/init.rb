# encoding: UTF-8

require 'siba/plugins/destination/dir/dest_dir'

module Siba::Destination
  module Dir 
    class Init 
      attr_accessor :dest_dir

      def initialize(options)
        dir = Siba::SibaCheck.options_string options, "dir"
        @dest_dir = Siba::Destination::Dir::DestDir.new dir
      end

      def backup(path_to_backup_file)
        @dest_dir.copy_backup_to_dest path_to_backup_file
      end

      # Put backup file into dir
      def restore(backup_name, dir)
        @dest_dir.restore_backup_to_dir backup_name, dir
      end

      # Returns an array of two-element arrays:
      # [backup_file_name, modification_time]
      def get_backups_list(backup_name)
        @dest_dir.get_backups_list backup_name
      end
    end
  end
end
