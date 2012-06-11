# encoding: UTF-8

module Siba::Source
  module Files
    class Files
      include Siba::LoggerPlug
      include Siba::FilePlug
      attr_accessor :files_to_include, :ignore, :include_subdirs

      def initialize(files_to_include, ignore, include_subdirs)
        @files_to_include = files_to_include
        @ignore = ignore
        @include_subdirs = include_subdirs
      end

      def backup(dest_dir)
        siba_file.run_this "backup" do
          size_digits = files_to_include.size.to_s.length
          files_to_include.each_index do |i|
            file = files_to_include[i]
            file = siba_file.file_expand_path file
            next if ignored? file

            is_file = siba_file.file_file? file
            unless is_file || siba_file.file_directory?(file)
              logger.error "Source file or directory does not exist: #{file}"
              next
            end

            path_to_subdir = Files.sub_dir_name i+1, size_digits, is_file, file, dest_dir
            siba_file.file_utils_mkpath path_to_subdir

            logger.debug file
            if is_file
              copy_file file, path_to_subdir
            else
              copy_dir file, path_to_subdir, false
            end
          end
        end
      end

      def restore(from_dir)
        siba_file.run_this do
          backup_dirs = Siba::FileHelper.entries(from_dir).select do |e|
            siba_file.file_directory? File.join(from_dir, e)
          end.sort

          if backup_dirs.size != files_to_include.size
            raise Siba::Error, "Number of source files does not equal the number of files that are in the backup"
          end

          backup_dirs.each_index do |i|
            backup_dir = backup_dirs[i]
            splitted = backup_dir.split "-"
            if splitted.size < 3
              logger.error "Failed to parse backup dir #{backup_dir}"
              next
            end
            dir_or_file = splitted[1]
            if dir_or_file != "dir" && dir_or_file != "file"
              logger.error "Failed to parse backup dir #{backup_dir}"
              next
            end
            is_dir = dir_or_file == "dir"
            path_to_backup_dir = File.join from_dir, backup_dir
            entry_name_to_restore = files_to_include[i]
            path_to_source = siba_file.file_expand_path entry_name_to_restore
            if is_dir
              siba_file.file_utils_mkpath path_to_source
              siba_file.file_utils_cp_r File.join(path_to_backup_dir, "."), path_to_source
              logger.info "Dir: #{path_to_source}"
            else
              restore_file path_to_backup_dir, entry_name_to_restore, path_to_source
            end
          end
        end
      end

      def restore_file(path_to_backup_dir, entry_name_to_restore, path_to_source)
        backup_dir_entries = Siba::FileHelper.entries path_to_backup_dir
        if backup_dir_entries.size != 1
          logger.error "Failed to restore file: #{entry_name_to_restore}"
          return
        end


        backup_file_name = backup_dir_entries[0]
        path_to_backup_file = File.join path_to_backup_dir, backup_file_name
        unless siba_file.file_file? path_to_backup_file
          logger.error "Failed to restore file: #{path_to_backup_file}"
          return
        end
        source_file_name = File.basename path_to_source
        unless source_file_name == backup_file_name
          logger.error "Failed to restore file, source file name '#{source_file_name}' is not the same as backup file name #{backup_file_name}"
          return
        end
        path_to_source_dir = File.dirname path_to_source
        siba_file.file_utils_mkpath path_to_source_dir
        siba_file.file_utils_cp path_to_backup_file, path_to_source_dir
        logger.info "File: #{path_to_source}"
      end

      def copy_file(file, dest_dir)
        siba_file.run_this "copy file" do
          return if ignored? file
          siba_file.file_utils_cp(file, dest_dir)
        end
      end

      def copy_dir(dir, dest_dir, create_subdir=false)
        siba_file.run_this "copy dir" do
          return if ignored? dir

          if create_subdir
            dest_dir = File.join(dest_dir, File.basename(dir))
            siba_file.file_utils_mkpath dest_dir
          end

          Siba::FileHelper.entries(dir).each do |entry|
            entry = File.join dir, entry
            if siba_file.file_file? entry
              copy_file entry, dest_dir
            elsif  siba_file.file_directory? entry
              copy_dir entry, dest_dir, true if include_subdirs
            else
              logger.error "Failed to backup: #{entry}."
            end
          end
        end
      end

      def ignored?(file)
        return false if ignore.nil?
        ignore.each do |pattern|
          if Siba::Source::Files::Files.path_match? pattern, file
            logger.info "Ignoring #{file}"
            return true
          end
        end
        false
      end

      class << self
        def path_match?(pattern, file)
          file.strip!
          pattern.strip!
          basename = File.basename(file)

          return File.fnmatch(pattern, basename, File::FNM_CASEFOLD) || # match basename against pattern
            File.fnmatch(pattern, file, File::FNM_CASEFOLD) # match whole path against pattern
        end

        def sub_dir_name(num, size_digits, is_file, src_file, dest_dir)
          basename = File.basename src_file
          basename = "root" if basename.empty? || basename == "/"
          sub_dir_name = "%0#{size_digits}d" % num
          sub_dir_name += is_file ? "-file" : "-dir"
          sub_dir_name += "-#{basename}"
          File.join dest_dir, sub_dir_name
        end
      end
    end
  end
end
