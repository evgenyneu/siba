# encoding: UTF-8

module Siba::Archive
  module Tar
    class Archive
      include Siba::FilePlug
      include Siba::LoggerPlug
      attr_accessor :compression 

      def initialize(compression)
        @compression = compression
        check_installed
      end

      # Returns the archive name
      def archive(sources_dir, dest_dir, dest_file_name)
        Siba::Archive::Tar::Archive.check_compression_type compression

        options = get_tar_option
        extension = Archive.get_tar_extension compression

        archive_name = "#{dest_file_name}.tar#{extension}"
        archive_path = File.join(dest_dir, archive_name)
        siba_file.run_this do
          raise Siba::Error, "Archive file already exists: #{archive_path}" if siba_file.file_file?(archive_path) || siba_file.file_directory?(archive_path)  

          siba_file.file_utils_cd dest_dir
          command_text = %(tar c#{options}f #{archive_name} -C "#{sources_dir}" .)
          # Using -C 'change directory' option to make it work on Windows
          # because Windows will not understand absolute path to tar: "tar cf c:\dir\file.tar ."
          siba_file.run_shell command_text, "Failed to archive: #{command_text}"
          raise Siba::Error, "Failed to create archive: #{command_text}" unless siba_file.file_file?(archive_path)
        end
        archive_name
      end

      def extract(archive_path, destination_dir)
        options = get_tar_option
        archive_name = File.basename archive_path
        archive_dir = File.dirname archive_path
        siba_file.file_utils_cd archive_dir 
        command_text = %(tar x#{options}f #{archive_name} -C "#{destination_dir}")
        # Using -C 'change directory' option to make it work on Windows
        # because Windows will not understand absolute path to tar: "tar xf c:\dir\file.tar"

        siba_file.run_this do
          unless siba_file.shell_ok? command_text
            raise Siba::Error, "Failed to extract archive: #{command_text}"
          end
        end
      end

      # Making sure tar is installed and works: tars and un-tars a test file
      def check_installed
        siba_file.run_this("test installed") do
          siba_file.run_shell("tar --help", "'tar' utility is not found. Please install it.")

          begin
            test_archive_and_extract
          rescue Exception
            logger.error "'tar' utility does not work correctly. Try reinstalling it."
            raise
          end
          logger.debug "TAR archiver is verified"
        end
      end

      def test_archive_and_extract        
        # archive
        src_dir = Siba::TestFiles.prepare_test_dir "tar-archive-src"
        dest_dir = Siba::TestFiles.mkdir_in_tmp_dir "tar-archive-dest"
        file_name = "myname"
        archive src_dir, dest_dir, file_name
        path_to_file = File.join(dest_dir,"#{file_name}.tar#{Archive.get_tar_extension(compression)}")
        raise unless siba_file.file_file? path_to_file

        # extract
        extracted_dir = Siba::TestFiles.mkdir_in_tmp_dir "tar-archive-extracted"
        extract path_to_file, extracted_dir

        # compare
        Siba::FileHelper.dirs_same? src_dir, extracted_dir
      end

      def self.check_compression_type(compression)
        raise Siba::CheckError, "'Compression' should be one of the following: #{CompressionTypes.join(', ')}" unless CompressionTypes.include?(compression)
      end

    protected
      def self.get_tar_extension(compression)
        case compression
        when "none" 
          ""
        when "gzip"
          ".gz"
        when "bzip2"
          ".bz2"
        else
          raise 
        end
      end

      def get_tar_option
        case compression
        when "none" 
          ""
        when "gzip"
          "z"
        when "bzip2"
          "j"
        else
          raise 
        end
      end
    end
  end
end
