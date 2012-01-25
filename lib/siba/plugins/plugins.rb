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
          plugins.each do |name, desc|
            installed = InstalledPlugins.installed?(category, name) ? "*" : " "
            str << sprintf(" #{installed} %-#{max_name_length}s %s\n", name, desc)
          end
          str << "\n"
        end
        str
      end
    end
  end
end
