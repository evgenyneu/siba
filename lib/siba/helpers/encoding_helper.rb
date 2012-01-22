# encoding: UTF-8

module Siba
  class EncodingHelper
    EXTERNAL_ENCODING = Encoding.find "external"
    INTERNAL_ENCODING = Encoding::UTF_8

    class << self
      def encode_to_external(value)
        encode value, EXTERNAL_ENCODING, INTERNAL_ENCODING
      end

      protected

      def encode(value, dst_encoding, src_encoding=nil)
        return encode_str value, dst_encoding, src_encoding if value.instance_of? String
        return encode_array value, dst_encoding, src_encoding if value.instance_of? Array
        value
      end

      def encode_str(str, dst_encoding, src_encoding=nil)
        return nil if str.nil?
        return str unless str.instance_of? String
        if str.encoding != dst_encoding
          str = str.encode(dst_encoding, src_encoding, {:invalid => :replace, :undef => :replace}) 
        end
        str
      end

      def encode_array(array, dst_encoding, src_encoding=nil)
        return nil if array.nil?
        return array unless array.instance_of? Array
        array.map {|a| encode_str a, dst_encoding, src_encoding}
      end
    end
  end
end

