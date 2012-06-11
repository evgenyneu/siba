# encoding: UTF-8

module Siba
  class TmpDir
    include Siba::FilePlug
    include Siba::LoggerPlug
    TmpDirPrefix = "siba-"

    def initialize
      @tmp_dir = nil
    end

    def get
      @tmp_dir ||= create
    end

    def cleanup
      siba_file.file_utils_remove_entry_secure @tmp_dir unless @tmp_dir.nil?
      @tmp_dir = nil
    end

    class << self
      include Siba::FilePlug
      include Siba::LoggerPlug
      def test_access
        siba_file.run_this "test access" do
          begin
            tmp_dir_obj = TmpDir.new
            test_dir = tmp_dir_obj.get
            raise unless siba_file.file_directory? test_dir
            tmp_dir_obj.cleanup
          rescue Exception
            logger.error %q{Can not create temporary directory.
Please make sure you have write permissions to the system temporary folder.
You can also specify the alternative location for temporary folder in options:

settings:
  tmp_dir: ~/your_tmp_dir
}
            raise
          end
          logger.debug "Access to temporary directory verified"
        end
      end
    end

  protected

    def create
      siba_file.run_this "create tmp dir" do
        tmp_dir_from_settings = Siba.settings && Siba.settings["tmp_dir"]
        tmp_path = nil
        if tmp_dir_from_settings.nil?
          tmp_path = siba_file.dir_mktmpdir TmpDirPrefix
        else
          tmp_path = File.join(siba_file.file_expand_path(tmp_dir_from_settings),
                                  "#{TmpDirPrefix}#{Siba::TestFiles.random_suffix}")
          siba_file.file_utils_mkpath tmp_path
        end
        tmp_path
      end
    end
  end

  module TmpDirPlug
    include Siba::FilePlug
    include Siba::LoggerPlug

    def tmp_dir
      if tmp_dir_clean?
        @tmp_dir_obj = TmpDir.new
        @tmp_dir = @tmp_dir_obj.get
      end
      @tmp_dir
    end

    def cleanup_tmp_dir
      unless @tmp_dir_obj.nil?
        logger.debug "Removing temporary files" if Siba::LoggerPlug.opened?
        siba_file.file_utils_cd Siba.current_dir
        @tmp_dir_obj.cleanup
        @tmp_dir_obj = nil
      end
      @tmp_dir = nil unless @tmp_dir.nil?
    rescue Exception => ex
      logger.fatal "Failed to remove temporary files" if Siba::LoggerPlug.opened?
      raise
    end

    def tmp_dir_clean?
      @tmp_dir.nil?
    end
  end
end
