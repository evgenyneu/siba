# encoding: UTF-8

require 'siba/plugin_loader.rb'

module Siba
  class Plugin
    CATEGORIES = ["source", "archive", "encryption", "destination"]
    class << self
      def valid_category?(category)
        Siba::Plugin::CATEGORIES.include? category
      end

      def categories_str
        Siba::Plugin::CATEGORIES.join(", ")
      end
    end
  end
end
