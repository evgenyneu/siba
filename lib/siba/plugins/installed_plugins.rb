# encoding: UTF-8

module Siba
  class InstalledPlugins
    class << self

      def installed?(category, type)
        types = all_installed[category]
        return false if types.nil? 
        types.include? type
      end

      def all_installed
        @installed ||= find_installed
      end

      def category_dir(category)
        File.expand_path "../#{category}/",  __FILE__
      end

      def type_dir(category, type)
        File.join category_dir(category), type
      end

    private

      def find_installed
        installed = {}
        all_local_gems.each do |item| 
          Siba::Plugins::CATEGORIES.each do |category|
            installed[category] ||= []
            gem_prefix_full = /^#{Siba::PluginLoader::GEM_PREFIX}#{category}-/
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

      def all_local_gems
        @local_gems ||= begin
                           Gem::Specification.all = nil
                           all = Gem::Specification.map{|a| a.name}
                           Gem::Specification.reset
                           all
                        end
      end

    end
  end
end
