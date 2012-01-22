# encoding: UTF-8

# Helper used to re-init constants
# Based on http://stackoverflow.com/questions/3375360/how-to-redefine-a-ruby-constant-without-warning
module SibaTest
  module RemovableConstants
    class << self
      def def_if_not_defined(cls, const, value)
        cls.const_set(const, value) unless cls.const_defined?(const)
      end

      def redef_without_warning(cls, const, value)
        cls.send(:remove_const, const) if cls.const_defined?(const)
        cls.const_set(const, value)
      end
    end
  end
end
