# encoding: UTF-8

require 'siba/plugins/archive/tar/archive'

module Siba::Archive
  module Tar
    DefaultCompression = "gzip"
    CompressionTypes = ["gzip", "bzip2", "none"]

    class Init 
      include Siba::LoggerPlug

      attr_accessor :archive 

      def initialize(options)
        options = options
        compression = Siba::SibaCheck.options_string options, "compression", true, DefaultCompression
        Archive.check_compression_type compression
        @archive = Archive.new compression
      end

      # Archive the contents of sources_dir and put it to dest_dir.
      # Return the archive file name. It must start with dest_file_name
      # and its ending must not vary with time.
      def backup(sources_dir, dest_dir, dest_file_name)
        logger.info "Archiving with 'tar', compression: '#{archive.compression}'"
        @archive.archive sources_dir, dest_dir, dest_file_name
      end

      # Extract archive file (path_to_archive) to_dir
      # No return value is expected.
      def restore(path_to_archive, to_dir)
        logger.info "Extracting 'tar' archive, compression: '#{archive.compression}'"
        @archive.extract path_to_archive, to_dir 
      end
    end
  end
end
