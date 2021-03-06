# encoding: UTF-8

require 'siba/tasks/siba_task'

module Siba
  class SibaTasks
    include Siba::FilePlug
    attr_accessor :tasks

    def initialize(options, path_to_options_yml, skip_source_task)
      @path_to_options_yml = path_to_options_yml
      raise 'Options are not loaded' if options.nil?

      @tasks = {}
      Siba::Plugins::CATEGORIES.each do |category|
        next if category == "source" && skip_source_task
        @tasks[category] = SibaTask.new options, category
      end
    end

    def backup
      siba_file.run_this "backup" do
        @tasks["source"].backup source_dir
        raise Siba::Error, "There are no files to backup" if Siba::FileHelper.dir_empty? source_dir
        OptionsBackup.save_options_backup path_to_options_yml, source_dir

        archive_file_name = @tasks["archive"].backup source_dir, archive_dir, SibaTasks.backup_name
        unless archive_file_name =~ /^#{SibaTasks.backup_name}/
          raise Siba::Error, "Archive file name must begin with: #{SibaTasks.backup_name}"
        end
        path_to_archive = File.join archive_dir, archive_file_name
        unless siba_file.file_file? path_to_archive
          raise Siba::Error, "Failed to create archive file: #{path_to_archive}"
        end

        name_of_encrypted_file = @tasks["encryption"].backup path_to_archive, encryption_dir
        unless name_of_encrypted_file =~ /^#{archive_file_name}/
          raise Siba::Error, "File name of encrypted file must begin with: #{archive_file_name}"
        end
        path_to_backup = File.join encryption_dir, name_of_encrypted_file
        unless siba_file.file_file? path_to_backup
          raise Siba::Error, "Failed to encrypt backup: #{path_to_backup}"
        end

        @tasks["destination"].backup path_to_backup
      end
    end

    def restore(backup_file_name)
      siba_file.run_this do
        @tasks["destination"].restore backup_file_name, destination_dir
        path_to_backup = File.join destination_dir, backup_file_name
        unless siba_file.file_file? path_to_backup
          raise Siba::Error, "Failed to get backup from destination: #{backup_file_name}"
        end

        archive_file_name = @tasks["encryption"].restore path_to_backup, encryption_dir
        path_to_archive = File.join encryption_dir, archive_file_name
        unless siba_file.file_file? path_to_archive
          raise Siba::Error, "Failed to get archive file: #{path_to_archive}"
        end

        @tasks["archive"].restore path_to_archive, source_dir
        if Siba::FileHelper.dir_empty? source_dir
          raise Siba::Error, "Failed to extract archive: #{path_to_archive}"
        end

        @tasks["source"] = OptionsBackup.load_source_from_backup source_dir if @tasks["source"].nil?
        @tasks["source"].restore source_dir
      end
    end

    def get_backups_list
      @tasks["destination"].plugin.get_backups_list Siba.backup_name
    end

    def self.backup_name(now=nil)
      if Siba::StringHelper.nil_or_empty Siba.backup_name
        raise Siba::Error, "Backup task name is not specified"
      end
      "#{Siba.backup_name}-#{SibaTasks.backup_name_suffix(now)}"
    end


  private
    attr_accessor :path_to_options_yml

    def source_dir
      @source_dir ||= TestFiles::mkdir_in_tmp_dir("src").freeze
    end

    def archive_dir
      @archive_dir ||= TestFiles::mkdir_in_tmp_dir("arc").freeze
    end

    def encryption_dir
      @encryption_dir ||= TestFiles::mkdir_in_tmp_dir("enc").freeze
    end

    def destination_dir
      @destination_dir ||= TestFiles::mkdir_in_tmp_dir("dest").freeze
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
  end
end
