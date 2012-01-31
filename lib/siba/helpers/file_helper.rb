# encoding: UTF-8

module Siba
  class FileHelper
    class << self
      include Siba::FilePlug

      def dir_empty?(dir)
        entries(dir).empty?
      end

      def dirs_count(dir)
        dirs(dir).size
      end

      # Reads a file in UTF-8 encoding
      def read(file)
        str = File.read file, { open_args: ["r:bom|utf-8"]}
        unless str.valid_encoding?
          raise Siba::Error, "Incorrect file encoding. Please save the options with UTF-8 encoding."
        end
        str
      end

      # Write to file in UTF-8 encoding
      def write(file, data)
        siba_file.file_utils_remove_entry_secure file if siba_file.file_file? file
        siba_file.file_open(file, "w:utf-8") do |file|
          file << data
        end
      end

      # Used to replace text in file
      # Example:
      #   change_file("/path") do |file_text|
      #     file_text.gsub "one", "two"
      #   end
      def change_file(path_to_file, &block)
        file_text = Siba::FileHelper.read path_to_file
        file_text = block.call file_text
        Siba::FileHelper.write path_to_file, file_text
      end

      # Retuns an array containing all dir entires except '.' and '..' dirs
      def entries(dir)
        siba_file.dir_entries(dir) - %w{ . .. }
      end

      # Retuns an array containing names of sub-directories located in the dir 
      def dirs(dir)
        entries(dir).select do |entry|
          siba_file.file_directory?(File.join(dir,entry))
        end
      end

      # Retuns an array containing names of files located in the dir 
      def files(dir)
        entries(dir).select do |entry|
          siba_file.file_file?(File.join(dir,entry))
        end
      end

      # Raises error if dirs are not identical 
      def dirs_same?(dir1, dir2)
        dir1_entries = siba_file.dir_entries dir1
        dir2_entries = siba_file.dir_entries dir2
        diff1 = (dir1_entries - dir2_entries).map{|i| File.join(dir1,i)}
        diff2 = (dir2_entries - dir1_entries).map{|i| File.join(dir2,i)}
        diff = diff1 + diff2
        msg = "The directories '#{File.basename(dir1)}' and '#{File.basename(dir2)}' are different: "
        raise Siba::Error, "#{msg}#{diff.take(10).join(', ')}" unless diff.empty?

        # compare files and directories
        dir1_entries.each do |dir|
          next if dir == "." || dir == ".."
          sub_dir1_entry = File.join dir1, dir
          sub_dir2_entry = File.join dir2, dir

          # compare files
          if siba_file.file_file? sub_dir1_entry
            raise "#{msg}'#{sub_dir2_entry}' is not a file" unless siba_file.file_file? sub_dir2_entry
            unless siba_file.file_utils_compare_file sub_dir1_entry, sub_dir2_entry
              raise Siba::Error, "#{msg}'#{sub_dir1_entry}' and '#{sub_dir2_entry}' files are different." 
            end
          end
          
          # compare permissions
          if (siba_file.file_stat(sub_dir1_entry).mode % 01000) != (siba_file.file_stat(sub_dir2_entry).mode % 01000)
            raise Siba::Error, "#{msg}'#{sub_dir1_entry}' and '#{sub_dir2_entry}' entries have different permissions." 
          end

          # compare sub-dirs
          if siba_file.file_directory? sub_dir1_entry
            raise Siba::Error, "#{msg}'#{sub_dir2_entry}' is not a directory" unless siba_file.file_directory? sub_dir2_entry
            dirs_same? sub_dir1_entry, sub_dir2_entry
          end
        end
      end
    end
  end
end
