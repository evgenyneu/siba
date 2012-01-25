# encoding: UTF-8

module Siba
  class Generator
    include Siba::FilePlug
    include Siba::KernelPlug

    PLUGIN_YAML_NAME = "options.yml"

    attr_accessor :name
    def initialize(name)
      @name = String.new name
    end

    # Generates yaml options file and returns its path
    def generate
      siba_file.run_this do
        file_path = @name.gsub /\.yml$/, ""
        file_path += ".yml"
        file_path = siba_file.file_expand_path file_path
        if siba_file.file_file?(file_path) || siba_file.file_directory?(file_path)
          raise Siba::Error, "Options file already exists: #{file_path}"
        end

        options_data = []
        Siba::Plugins::PLUGINS_HASH.each do |category, types|
          type = nil
          if types.size > 1
            max_type_length = types.keys.max do |a,b|
              a.length <=> b.length
            end.length + 5

            siba_kernel.puts "\nChoose #{category} plugin:"
            types.keys.each_index do |i|
              type = types.keys[i]
              siba_kernel.puts "  #{i+1}. #{Siba::Plugins.plugin_type_and_description(category, type, max_type_length)}"
            end

            type = Siba::Generator.get_plugin_user_choice types.keys
            if type.nil?
              siba_kernel.puts "Aborted"
              return
            end
          else
            type = types.keys.first
          end

          options = Siba::Generator.load_plugin_yaml_content category, type 
          unless options =~ /^\s*type:/
            options = "type: #{type}\n" + options
          end

          options.gsub! /^/, "  "
          options = "#{category}:\n" + options
          options_data << options
        end

        file_data = options_data.join("\n")
        file_data = "# SIBA options file\n" + file_data
        dest_dir = File.dirname file_path
        siba_file.file_utils_mkpath(dest_dir) unless siba_file.file_directory?(dest_dir)
        Siba::FileHelper.write file_path, file_data
        file_path
      end

    end

    class << self
      include Siba::FilePlug
      include Siba::KernelPlug

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

      def get_plugin_user_choice(types)
        msg = "\nEnter plugin number from 1 to #{types.size}, or 0 to exit.\n> "
        siba_kernel.printf msg
        while true
          user_choice = siba_kernel.gets.chomp
          number = Integer(user_choice) rescue -1
          if number >= 0 && number <= (types.size + 1)
            return if number == 0
            return types[number-1]
          else
            siba_kernel.printf msg
          end 
        end
      end
    end
  end
end
