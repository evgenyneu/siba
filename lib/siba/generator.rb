# encoding: UTF-8

module Siba
  class Generator
    include Siba::FilePlug

    attr_accessor :name
    def initialize(name)
      @name = name
    end

    def generate
      siba_file.run_this do
        name.gsub! /\.yml$/, ""
        name +=".yml"
        name = siba_file.file_expand_path name
        raise Siba::Error, "Options file ready exists: #{name}" if siba_file.file_file?(name) || siba_file_file_directory?(name)


      end
    end
  end
end
