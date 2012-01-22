# encoding: UTF-8

module Siba
  class << self
    include Siba::TmpDirPlug
    attr_accessor :settings, :backup_name, :current_dir

    def cleanup
      Siba.cleanup_tmp_dir
    ensure
      LoggerPlug.close
    end
  end
end
