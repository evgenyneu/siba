# encoding: UTF-8

require 'siba/plugin_loader.rb'

module Siba
  class Plugin
    class << self
      def valid_category?(category)
        Siba::Plugin::CATEGORIES.include? category
      end

      def categories_str
        Siba::Plugin::CATEGORIES.join(", ")
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
            str << sprintf("  %-#{max_name_length}s %s\n", name, desc)
          end
          str << "\n"
        end
        str
      end
    end

    private

    PLUGINS_HASH = Siba::OptionsLoader.load_hash_from_yml(File.expand_path "../plugins.yml", __FILE__)

    public

    CATEGORIES = PLUGINS_HASH.keys
  end
end
