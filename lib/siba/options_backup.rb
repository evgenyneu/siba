# encoding: UTF-8

module Siba
  class OptionsBackup
    OPTIONS_BACKUP_FILE_NAME = "siba_options_backup.yml"

    class << self
      include Siba::FilePlug
      include Siba::LoggerPlug

      def save_options_backup(path_to_options, to_dir)
        data = Siba::FileHelper.read path_to_options
        data << "\n\ncurrent_dir: \"#{Siba::StringHelper.escape_for_yaml(Siba.current_dir)}\""
        options_backup_path = File.join to_dir, OPTIONS_BACKUP_FILE_NAME
        siba_file.run_this do
          Siba::FileHelper.write options_backup_path, data
        end
      end

      def load_source_from_backup(dir)
        path_to_options_backup = File.join dir, OPTIONS_BACKUP_FILE_NAME
        options_backup = Siba::OptionsLoader.load_yml path_to_options_backup
        Siba.current_dir = SibaCheck.options_string options_backup, "current_dir"
        unless siba_file.file_directory? Siba.current_dir
          begin
            siba_file.file_utils_mkpath Siba.current_dir
          rescue Exception
            logger.error "Can not access the backup current directory #{Siba.current_dir}"
            raise
          end
        end
        SibaTask.new options_backup, "source"
      end
    end
  end
end

