# encoding: UTF-8

module Siba::C6y
  module Demo                 
    class Init                 
      include Siba::FilePlug
      include Siba::LoggerPlug

      def initialize(options)
## init_example.rb ##
      end                      

      # Archive the contents of sources_dir and put it to dest_dir.
      # Return the archive file name. It must start with dest_file_name
      # and its ending must not vary with time.
      def backup(sources_dir, dest_dir, dest_file_name)
## examples.rb ##
      end

      # Extract contents of archive file (path_to_archive) to_dir
      # No return value is expected.
      def restore(path_to_archive, to_dir)
        logger.info "Extracting 'tar' archive, compression: '#{archive.compression}'"
        @archive.extract path_to_archive, to_dir 
      end
    end
  end
end
