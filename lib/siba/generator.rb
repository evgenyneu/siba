# encoding: UTF-8

module Siba
  class Generator
    include Siba::FilePlug

    PLUGIN_YAML_NAME = "options.yml"

    attr_accessor :name
    def initialize(name)
      @name = name
    end

    # Generates yaml file and return its path
    def generate
      siba_file.run_this do
        @name.gsub! /\.yml$/, ""
        @name += ".yml"
        @name = siba_file.file_expand_path name
        if siba_file.file_file?(name) || siba_file.file_directory?(name)
          raise Siba::Error, "Options file already exists: #{name}"
        end

        options_data = []
        Siba::Plugins::PLUGINS_HASH.each do |category, types|
          type = types.keys[0]
          options = Siba::Generator.load_plugin_yaml_content category, type 
          unless options =~ /^\s*type:/
            options = "type: #{type}\n" + options
          end

          options.gsub! /^/, "  "
          options = "#{category}:\n" + options
          options_data << options
        end
        file_data = options_data.join("\n")
        file_data = "# SIBA options file\n\n" + file_data
        Siba::FileHelper.write name, file_data
        name
      end
    end

    class << self
      include Siba::FilePlug

      def load_plugin_yaml_content(category, type)
        siba_file.run_this do
          path = get_plugin_yaml_path category, type
          begin
            Siba::OptionsLoader.load_erb path
          rescue Exception => ex
            raise "Failed to load options for #{InstalledPlugins.plugin_category_and_type(category, type)} plugin from file: #{path}. Error: #{ex.message}"
          end
        end
      end 

      def get_plugin_yaml_path(category, type)
        siba_file.run_this do
          dir = InstalledPlugins.plugin_path(category, type)
          options_path = File.join dir, PLUGIN_YAML_NAME
          unless siba_file.file_file? options_path
            raise Siba::Error, "Failed to load options for #{InstalledPlugins.plugin_category_and_type(category, type)} plugin from file: #{options_path}"
          end
          options_path
        end
      end
    end
  end
end
