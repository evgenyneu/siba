# encoding: UTF-8

module Siba::C6y
  module Demo
    class Init
      include Siba::FilePlug
      include Siba::LoggerPlug

      def initialize(options)
## init_example.rb ##
      end

      # Collect source files and put them into dest_dir
      # No return value is expected
      def backup(dest_dir)
## examples.rb ##
      end

      # Restore source files from_dir
      # No return value is expected
      def restore(from_dir)
      end
    end
  end
end
