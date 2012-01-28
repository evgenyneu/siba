# encoding: UTF-8

module Siba
  class StringHelper
    class << self
      # Helps to use a string in URLs and file names by
      # replacing all non-alphanumeric characters with '-'
      # and converting to lowercase
      def str_to_alphnumeric(str)
        str.downcase.gsub(/[^ a-z0-9]/,' ').strip.gsub(/ {1,}/,'-')
      end

      def nil_or_empty(str)
        str.nil? || str.strip.empty?
      end

      # Convers a string to CamelCase. Based on Rails ActiveSupport::Inflector.camelize.
      def camelize(str)
        str = str.capitalize
        str.gsub(/(?:_|-)([a-z\d]*)/i) { "#{$1.capitalize}" }
      end

      def escape_for_yaml(str)
        str.gsub("\\","\\\\\\").gsub("\"","\\\"")
      end

      def format_time(time)
        time.strftime("%B %e, %Y")
      end
    end
  end
end
