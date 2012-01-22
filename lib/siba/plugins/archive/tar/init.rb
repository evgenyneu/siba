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

      def backup(sources_dir, dest_dir, dest_file_name)
        logger.debug "Archiving with 'tar', compression: '#{archive.compression}'"
        @archive.archive sources_dir, dest_dir, dest_file_name
      end
    end
  end
end
