# encoding: UTF-8

require 'fileutils'
require 'tmpdir'
require 'open3'

module Siba
  class SibaFile
    def run_this(name="noname")
      yield
    end

    DIR_REGEXP = /^dir_/
    FILE_REGEXP = /^file_/
    FILE_UTILS_REGEXP = /^file_utils_/

    def self.get_file_class(meth)
      case meth
      when FILE_UTILS_REGEXP
        return FileUtils, meth.to_s.gsub(FILE_UTILS_REGEXP, "")
      when DIR_REGEXP
        return Dir, meth.to_s.gsub(DIR_REGEXP, "")
      when FILE_REGEXP
        return File, meth.to_s.gsub(FILE_REGEXP, "")
      end
    end

    def method_missing(meth, *args, &block)
      file_class, class_meth = SibaFile.get_file_class meth
      if file_class
        file_class.send(class_meth, *args, &block)
      else
        super
      end
    end

    def respond_to?(meth)
      if SibaFile.get_file_class meth
        true
      else
        super
      end
    end

    def file_expand_path(file_name, dir_string=nil)
      file_utils_cd Siba.current_dir unless Siba.current_dir.nil?
      File.expand_path file_name, dir_string
    end

    # Runs shell command and raises error if it fails
    # returns output (both stdout and stderr)
    def run_shell(command, fail_message=nil)
      strout, status = Open3.capture2e command
      raise strout if status.to_i != 0
      return strout
    rescue Exception => ex
      fail_message ||= "Failed to run the command: #{command}"
      raise Siba::Error, "#{fail_message}
#{ex.message}"
    end

    # Runs the shell command.
    # Works the same way as Kernel.system method but without showing the output.
    # Returns true if it was successfull.
    def shell_ok?(command)
      # Using Open3 instead of `` or system("cmd") in order to hide stderr output
      sout, status = Open3.capture2e command
      return status.to_i == 0
    rescue
      return false
    end
  end

  # Used to inject "siba_file" to classes that include this module
  module FilePlug
    def siba_file
      FilePlug.siba_file
    end

    def self.siba_file
      @siba_file ||= SibaFile.new
    end

    # It is used in test to insert mock SibaFile object
    def self.siba_file=(val)
      @siba_file = val
    end
  end
end
