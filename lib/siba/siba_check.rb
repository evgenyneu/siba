# encoding: UTF-8

module Siba
  class SibaCheck
    class << self
      def options_bool(options, key_name, is_optional = false, default_value=false)
        check_options options, key_name, [TrueClass, FalseClass], is_optional, default_value
      end

      def options_hash(options, key_name, is_optional = false, default_value=nil)
        check_options options, key_name, Hash, is_optional, default_value
      end

      def options_string(options, key_name, is_optional = false, default_value=nil)
        check_options(options, key_name, String, is_optional, default_value)
      end

      def options_string_array(options, key_name, is_optional = false, default_value=nil)
        value = options[key_name]
        if value.nil?
          return default_value if is_optional
          raise Siba::CheckError, "'#{key_name}' option is not defined"
        end

        begin
          if value.is_a? Array
            value.each_index do |i|
              value[i] = try_to_s value[i], key_name
            end
          else
            value = [ try_to_s(value, key_name) ]
          end
        rescue Exception
          raise Siba::CheckError, "'#{key_name}' option should be string or an array of strings"
        end
        value
      end

      def hash(obj, name, is_optional=false)
        if obj.nil?
          return nil if is_optional
          raise Siba::CheckError, "'#{name}' option is not defined"
        end
        raise Siba::CheckError, "'#{name}' option should be of [Hash] type" unless obj.is_a? Hash
        obj
      end
      
    private

      def try_to_s(value, key_name)
        raise Siba::CheckError if [Array, Hash].any?{|a| value.is_a?(a)}
        value = value.to_s.strip
        raise Siba::CheckError if value.empty?
        value
      end

      def check_options(options, key_name, item_type, is_optional = false, default_value = nil)
        value = options[key_name]
        if value.nil?
          raise Siba::CheckError, "'#{key_name}' option is not defined" unless is_optional
          return default_value
        end

        if item_type == String
          value = try_to_s value, key_name
        else
          item_type = [item_type] unless item_type.is_a?(Array) 
          raise Siba::CheckError, "'#{key_name}' option should be of #{item_type.to_s} type" if item_type.none? {|i| value.is_a? i } 
        end
        value
      end
    end
  end
end
