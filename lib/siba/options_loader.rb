# encoding: UTF-8

require 'erb'
require 'yaml'

module Siba
  module OptionsLoader
    class << self
      include Siba::LoggerPlug
      def load_yml(path_to_yml)
        logger.debug "Loading options from #{path_to_yml}"
        raise Siba::Error, "Options file must have .yml extension: #{path_to_yml}" unless path_to_yml =~ /\.yml$/

        unless File.exists? path_to_yml
          raise Siba::Error, "Could not read the options file #{path_to_yml}.
  Make sure the file exists and you have read access to it." 
        end

        begin
          hash = load_hash_from_yml path_to_yml
          raise Siba::Error, "invalid format" unless hash.is_a? Hash
          return hash
        rescue Exception => e
          raise Siba::Error, "Error loading options file #{path_to_yml}: " + e.message
        end
      end

      def load_hash_from_yml(path_to_yml)
        yml_str = Siba::FileHelper.read path_to_yml
        YAML.load(ERB.new(yml_str).result)
      end
    end
  end
end
