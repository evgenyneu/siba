# encoding: UTF-8

require 'siba/plugins/plugin_loader.rb'
require 'siba/plugins/installed_plugins.rb'

module Siba
  class Plugins
    PLUGINS_HASH = Siba::OptionsLoader.load_hash_from_yml(File.expand_path "../plugins.yml", __FILE__)
    CATEGORIES = PLUGINS_HASH.keys

    class << self
      def valid_category?(category)
        Siba::Plugins::CATEGORIES.include? category
      end

      def categories_str
        Siba::Plugins::CATEGORIES.join(", ")
      end

      def plugin_description(category, type)
        unless Siba::InstalledPlugins.installed? category, type
          raise Siba::Error, "Plugin is not installed: #{Siba::InstalledPlugins.plugin_category_and_type(category, type)}"
        end
        PLUGINS_HASH[category][type]
      end

      def plugin_type_and_description(category, type, name_column_length)
        desc = plugin_description category, type
        sprintf("%-#{name_column_length}s %s", type, desc)
      end

      def get_list
        str = ""
        all_names = PLUGINS_HASH.values.map{|a| a.keys}.flatten
        max_name_length = all_names.max do |a,b|
          a.length <=> b.length
        end.length + 5

        PLUGINS_HASH.each do |category, plugins|
          str << "#{category.capitalize}"
          str << "s" if plugins.size > 1
          str << ":\n"
          plugins.each do |type, desc|
            installed = InstalledPlugins.installed?(category, type) ? "*" : " "
            str << " #{installed} #{plugin_type_and_description(category, type, max_name_length)}\n"
          end
          str << "\n"
        end
        str
      end
    end
  end
end
