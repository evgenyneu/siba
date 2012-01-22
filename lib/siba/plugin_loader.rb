# encoding: UTF-8

module Siba
  class PluginLoader
    include Siba::LoggerPlug
    include Siba::FilePlug

    GemPrefix = "siba-"
    InitClassName = "Init"

    def self.loader
      @loader ||= PluginLoader.new 
    end

    def load(category, type, options)
      unless Siba::Plugin.valid_category? category
        raise PluginLoadError, "Incorrect plugin category '#{category}'. Available plugin categories are: #{Siba::Plugin.categories_str}"
      end

      raise PluginLoadError, "Options data is incorrect for #{plugin_category_and_type}." unless options.is_a? Hash

      @category=category
      @type=type
      @options = options
      logger.debug "Loading #{plugin_category_and_type}"
      
      require_plugin
      plugin_module = get_plugin_module
      plugin_type_module = get_plugin_type_module plugin_module
      init_class = get_plugin_init_class plugin_type_module
      init_plugin(init_class)
    end

  private
    attr_accessor :category, :type, :options

    def require_plugin
      path_to_init_file = File.join(plugin_dir, "init.rb")
      if File.exists?(path_to_init_file)
        require path_to_init_file
      else
        gem_name = "#{GemPrefix}#{category}-#{type}"
        begin
          Gem::Specification.find_by_name(gem_name) 
        rescue Gem::LoadError
          raise PluginLoadError, "Unknown type '#{type}' for '#{category}' plugin. #{available_types_msg}"
        end
        require gem_name
      end
    end

    def get_plugin_module
      plugin_module_name = "#{category.capitalize}"
      Siba.const_get(plugin_module_name)
    rescue Exception
      raise PluginLoadError, "Failed to load #{plugin_category_and_type}: module 'Siba::#{plugin_module_name}' is undefined." 
    end

    def get_plugin_type_module(plugin_module)
      plugin_type_module_name = StringHelper.camelize type
      plugin_module.const_get(plugin_type_module_name)
    rescue
      raise PluginLoadError, "Failed to load #{plugin_category_and_type}: module 'Siba::#{category.capitalize}::#{plugin_type_module_name}' is undefined."
    end

    def get_plugin_init_class(plugin_type_module)
      plugin_type_module.const_get InitClassName
    rescue Exception => e
      raise PluginLoadError, "#{InitClassName} class is undefined for #{plugin_category_and_type}."
    end

    def init_plugin(plugin_init_class)
      plugin_init_class.new options
    rescue ArgumentError
      logger.error "Failed to load #{plugin_category_and_type}: 'initialize' method is not defined or has wrong agruments."
      raise
    end

    def plugin_category_and_type
      "#{category}#{type.nil? ? "" : '-' + type} plugin"
    end

    def plugins_root_dir
      File.expand_path "../plugins/#{category}/",  __FILE__
    end

    def plugin_dir
      File.join plugins_root_dir, type
    end

    def available_types_msg
      return "No #{category} plugins are installed." if find_all_installed.empty?
      return "Available types are: #{find_all_installed.join(", ")}." if find_all_installed.size > 1
      "Available type is '#{find_all_installed.join(", ")}'."
    end

    def find_all_installed
      types = Dir.glob(File.join(plugins_root_dir,"*")).select { |entry|
        File.directory? entry
      }.select{|dir| File.file?(File.join(dir,"init.rb")) }
        .map{|directory| File.basename(directory)}

      Gem::Specification.each do |item| 
        gem_prefix_full = /^#{GemPrefix}#{category}-/
        types << item.name.gsub(gem_prefix_full, '') if item.name =~ /#{gem_prefix_full}.*$/
      end
      types
    end
  end
end
