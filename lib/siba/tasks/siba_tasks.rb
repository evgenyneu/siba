# encoding: UTF-8

require 'siba/tasks/siba_task'

module Siba
  class SibaTasks
    include Siba::FilePlug
    attr_accessor :options, :tasks, :path_to_options_yml

    OPTIONS_BACKUP_FILE_NAME = ".siba_options_backup.yml"

    def initialize(options, path_to_options_yml)
      @options = options
      @path_to_options_yml = path_to_options_yml
      raise 'Options are not loaded' if options.nil?

      @tasks = {}
      Siba::Plugins::CATEGORIES.each do |category|
        @tasks[category] = SibaTask.new options, category
      end
    end

    def backup
      siba_file.run_this "backup" do
        @tasks["source"].backup source_dir
        raise Siba::Error, "There are no files to backup" if Siba::FileHelper.dir_empty? source_dir
        save_options_backup

        path_to_archive = @tasks["archive"].backup source_dir, archive_dir, SibaTasks.backup_name
        raise Siba::Error, "Failed to create archive file: #{path_to_archive}" unless siba_file.file_file? path_to_archive

        path_to_backup = @tasks["encryption"].backup path_to_archive
        raise Siba::Error, "Failed to encrypt backup: #{path_to_backup}" unless siba_file.file_file? path_to_backup

        @tasks["destination"].backup path_to_backup
      end
    end

    def self.backup_name(now=nil)
      if Siba::StringHelper.nil_or_empty Siba.backup_name
        raise Siba::Error, "Backup task name is not specified" 
      end
      "#{Siba.backup_name}-#{SibaTasks.backup_name_suffix(now)}"
    end

    def source_dir
      mkdir_if_missing(File.join Siba.tmp_dir, "source")
    end

  private

    def save_options_backup
      options_backup_path = File.join source_dir, SibaTasks::OPTIONS_BACKUP_FILE_NAME
      siba_file.file_utils_cp path_to_options_yml, options_backup_path
    end

    def self.backup_name_suffix(now=nil)
      now ||= Time.now

      # Monthly backup on the 1st day of each month
      # "month-01" through "month-12"
      return "month-#{"%02d" % now.month}" if now.day == 1 

      # Weekly backup on Sunday
      # "week-1-sun" through "week-5-sun"
      return "week-#{(now.day-1) / 7 + 1}-sun" if now.wday == 0

      # Daily backup
      # "day-2-mon" through "day-7-sat"
      "day-#{now.wday+1}-#{now.strftime("%a").downcase}"  
    end

    def archive_dir
      mkdir_if_missing(File.join Siba.tmp_dir, "archive")
    end

    def mkdir_if_missing(dir)
      siba_file.file_utils_mkpath dir unless siba_file.file_directory?(dir)
      dir
    end
  end
end
