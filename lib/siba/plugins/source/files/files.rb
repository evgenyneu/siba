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
        sources, current_dir = get_original_sources from_dir  
      end

      # Returns original sources from options backup yaml
      def get_original_sources(from_dir)
        path_to_options_backup = File.join from_dir, Siba::SibaTasks::OPTIONS_BACKUP_FILE_NAME
        unless siba_file.file_file? path_to_options_backup
          raise Siba::Error, "Options backup YAML is not find: #{path_to_options_backup}"
        end
        options = Siba::OptionsLoader.load_yml path_to_options_backup
        source = Siba::SibaCheck.options_hash options, "source"    
        include_files = Siba::SibaCheck.options_string_array source, "include"
        current_dir = Siba::SibaCheck.options_string options, "current_dir"
        return include_files, current_dir
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
              logger.error "Failed to backup: #{file}."
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
