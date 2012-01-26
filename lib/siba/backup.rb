# encoding: UTF-8

module Siba
  class Backup
    include Siba::LoggerPlug
    include Siba::FilePlug

    def backup(path_to_options_yml, path_to_log_file)
      run_backup path_to_options_yml, path_to_log_file
    ensure
      Siba.cleanup
    end

private

    def run_backup(path_to_options_yml, path_to_log_file)
      LoggerPlug.create "Backup", path_to_log_file
      options = Siba::OptionsLoader.load_yml path_to_options_yml
      Siba.current_dir = File.dirname path_to_options_yml
      Siba.settings = options["settings"] || {}
      Siba.backup_name = File.basename path_to_options_yml, ".yml"

      TmpDir.test_access 
      SibaTasks.new(options, path_to_options_yml).backup
      Siba.cleanup_tmp_dir
    rescue Exception => e 
      logger.fatal e
      logger.log_exception e, true
    end
  end
end
