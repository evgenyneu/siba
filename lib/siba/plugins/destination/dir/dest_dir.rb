# encoding: UTF-8

module Siba::Destination
  module Dir 
    class DestDir
      include Siba::FilePlug
      include Siba::LoggerPlug
      attr_accessor :dir

      def initialize(dir)
        @dir = siba_file.file_expand_path dir
        test_dir_access
      end

      def copy_backup_to_dest(path_to_backup)
        siba_file.run_this "copy backup to dest" do
          logger.info "Copying backup to destination directory: #{dir}"
          unless siba_file.file_file? path_to_backup
            raise Siba::Error, "Backup file '#{path_to_backup}' does not exist"
          end
          unless siba_file.file_directory? dir
            raise Siba::Error, "Destination directory '#{dir}' does not exist" 
          end
          siba_file.file_utils_cp(path_to_backup, dir) 
        end
      end
      
      def test_dir_access
        siba_file.run_this "test dir access" do
          # create dest dir
          begin
            siba_file.file_utils_mkpath dir unless siba_file.file_directory? dir
          rescue Exception
            logger.error "Failed to create destination dir '#{dir}'."
            raise
          end

          # copy a test file to dest dir
          begin          
            test_file = Siba::TestFiles.prepare_test_file "destination_dir", dir
            raise "Can not find the test file." unless siba_file.file_file? test_file
            siba_file.file_utils_remove_entry_secure test_file
          rescue Exception
            logger.error "Could not write to destination dir '#{dir}'"
            raise
          end

          logger.debug "Access to destination directory is verified"
        end
      end
    end
  end
end 
