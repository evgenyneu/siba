# encoding: UTF-8

module Siba::C6y
  module Demo                 
    class Init                 
      include Siba::FilePlug
      include Siba::LoggerPlug

      # The main plugin initialization method
      def initialize(options)  
        # Load and validate options
        key = Siba::SibaCheck.options_string options, "key"
        key2 = Siba::SibaCheck.options_string options, "missing", true, "default value"
        array = Siba::SibaCheck.options_string_array options, "array"
        bool = Siba::SibaCheck.options_bool options, "bool"
        Siba.settings # the global app settings (value of "settings" key in YAML file)

        # The backup is started after ALL plugins are initialized
        # Therefore, this is a good place to do some checking (access, permissions etc.)
        # to make sure everything works before backup is started
        raise Siba::Error, "Something wrong" if false
      end                      

      # Write path_to_backup_file to destination
      # No return value is expected
      def backup(path_to_backup_file) 
        # -- Logging --
        # "logger" object is available after including Siba::LoggerPlug
        logger.debug "Detailed information shown in 'verbose' mode and in log file"
        logger.info "Useful information about current operation"
        logger.warn "A warning"
        logger.error "A handleable error message"
        raise Siba::Error, "An unhandleable error. It will be caught at the upper level and logged." if false

        # -- File operations --
        # "siba_file" object is available after including Siba::FilePlug
        # You can use it for file operations 
        # instead of calling Dir, File, FileUtils directly
        # It allows to mock the methods during unit tests
        # but run them during integration tests.
        current_dir = siba_file.dir_pwd # for Dir.pwd
        dir = siba_file.file_directory? current_dir #for File.directory?
        siba_file.file_utils_cd dir #for FileUtils.cd
        siba_file.run_this do
          # This code will not be run during unit tests
          # but only during normal execution and integration tests
          files_and_dirs = Siba::FileHelper.entries(current_dir)
        end

        # These methods can be used directly as they do not access file system
        File.join "a","b"
        File.basename "a"
        File.dirname "a"

        # -- Temporary dirs and files --
        # You can use Siba.tmp_dir to store temporary files or dirs.
        tmp_dir = Siba.tmp_dir

        # If you need to create a sub-dir with a random name in the temp dir, 
        # use the following helper method:
        path_to_tmp_dir = Siba::TestFiles.mkdir_in_tmp_dir "you_dir_prefix" 

        # Tmp dir will be removed automatically when siba finishes or crashes,
        # so there is no need to clean anything.
        
        # Siba::FileHelper methods
        my_file = File.join tmp_dir, "myfile"
        Siba::FileHelper.write my_file, "Write UTF-8 text"
        Siba::FileHelper.read my_file
      end
    end
  end
end
