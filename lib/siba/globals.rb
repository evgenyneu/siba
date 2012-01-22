# encoding: UTF-8

module Siba

  class << self
    include Siba::TmpDirPlug
    include Siba::FilePlug

    attr_accessor :settings, :backup_name, :current_dir
    Siba.settings = {}
    Siba.current_dir = Siba::FilePlug.siba_file.file_utils_pwd

    def cleanup
      Siba.cleanup_tmp_dir
    ensure
      LoggerPlug.close
    end
  end
end
