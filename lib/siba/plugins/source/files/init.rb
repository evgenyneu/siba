# encoding: UTF-8

require 'siba/plugins/source/files/files'

module Siba::Source
  module Files
    class Init 
      attr_accessor :files

      def initialize(options)
        files_to_include = Siba::SibaCheck.options_string_array options, "include"
        ignore = Siba::SibaCheck.options_string_array options, "ignore", true
        include_subdirs = Siba::SibaCheck.options_bool options, "include_subdirs", true, true
        @files = Siba::Source::Files::Files.new files_to_include, ignore, include_subdirs
      end

      def backup(dest_dir)
        @files.backup dest_dir
      end
    end
  end
end
