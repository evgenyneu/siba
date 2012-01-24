# encoding: UTF-8

module Siba
  class GemHelper
    class << self
      def all_local_gems
        @local_gems ||= begin
                           Gem::Specification.all = nil
                           all = Gem::Specification.to_a
                           Gem::Specification.reset
                           all
                        end
      end

      def gem_path(name)
        gem_spec = all_local_gems.find {|a| a.name==name}
        raise Siba::Error, "Gem #{name} is not installed" if gem_spec.nil?
        gem_spec.full_gem_path
      end
    end
  end
end
