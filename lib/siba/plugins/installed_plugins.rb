# encoding: UTF-8

module Siba
  class InstalledPlugins
    GEM_PREFIX = "siba-"

    class << self
      include Siba::FilePlug

      def installed?(category, type)
        types = all_installed[category]
        return false if types.nil? 
        types.include? type
      end
      
      def all_installed
        @installed ||= find_installed
      end

      def plugin_path(category, type)
        unless installed? category, type
          raise Siba::Error, "Plugin #{plugin_category_and_type(category, type)} is not installed"
        end
        siba_file.run_this do
          path = type_dir category, type
          unless siba_file.file_directory? path
            path = Siba::GemHelper.gem_path gem_name(category, type)
            path = File.join path, "lib", gem_name(category, type) 
          end
          unless siba_file.file_directory? path
            raise Siba::Error, "Failed to get path to plugin #{plugin_category_and_type(category, type)}"
          end
          path
        end
      end

      def category_dir(category)
        File.expand_path "../#{category}/",  __FILE__
      end

      def type_dir(category, type)
        File.join category_dir(category), type
      end

      def gem_name(category, type)
        "#{GEM_PREFIX}#{category}-#{type}" 
      end

      def plugin_category_and_type(category, type)
        "#{category}#{type.nil? ? "" : '-' + type}"
      end

    private

      def find_installed
        installed = {}
        Siba::GemHelper.all_local_gems.map{|a| a.name}.each do |item| 
          Siba::Plugins::CATEGORIES.each do |category|
            installed[category] ||= []
            gem_prefix_full = /^#{GEM_PREFIX}#{category}-/
            installed[category] << item.gsub(gem_prefix_full, '') if item =~ /#{gem_prefix_full}.*$/
          end
        end

        Siba::Plugins::CATEGORIES.each do |category|
          installed[category] += Dir.glob(File.join(category_dir(category),"*")).select { |entry|
            File.directory? entry
          }.select{|dir| File.file?(File.join(dir,"init.rb")) }
            .map{|directory| File.basename(directory)}
        end
 
        installed
      end

    end
  end
end
