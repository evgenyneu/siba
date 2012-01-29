        # Examples:
        #
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
        # instead of calling Dir, File, FileUtils directly.
        # It mocks all methods of these classes in unit tests
        # but runs them normally and in integration tests.
        current_dir = siba_file.dir_pwd # for Dir.pwd
        dir = siba_file.file_directory? current_dir #for File.directory?
        siba_file.file_utils_cd dir #for FileUtils.cd
        siba_file.run_this do
          # The block will not be run during unit tests
        end

        # These methods can be used directly as they do not access file system
        File.join "a","b"
        File.basename "a"
        File.dirname "a"

        # Helpers to run shell commands (wont be run in unit tests)
        siba_file.shell_ok? "cd ."
        output = siba_file.run_shell "git help"

        # -- Temporary dirs and files --
        # Use Siba.tmp_dir to store temporary files
        tmp_dir = Siba.tmp_dir

        # Create a sub-dir with a random name in the temp dir
        path_to_tmp_dir = Siba::TestFiles.mkdir_in_tmp_dir "you_dir_prefix" 

        # Note: Siba.tmp_dir will be removed automatically, 
        # so there is no need to clean anything.
        
        # Some Siba::FileHelper methods
        files_and_dirs = Siba::FileHelper.entries current_dir
        my_file = File.join tmp_dir, "myfile"
        Siba::FileHelper.write my_file, "Write UTF-8 text"
        Siba::FileHelper.read my_file
      end
