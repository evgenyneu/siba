# encoding: UTF-8

module Siba
  class SibaTask
    include Siba::LoggerPlug

    attr_accessor :category, :type, :options, :plugin

    def initialize(options, category)
      @category = category
      load Siba::SibaCheck.options_hash(options, category)
    rescue
      logger.error "Failed to load #{category} plugin"
      raise
    end

    def backup(*args)
      logger.debug "Running #{category}/#{type}"
      @plugin.backup *args
    rescue Exception
      logger.error "Failed to backup #{category}/#{type}"
      raise
    end

    def restore(*args)
      logger.debug "Restoring #{category}/#{type}"
      @plugin.restore *args
    rescue Exception
      logger.error "Failed to restore #{category}/#{type}"
      raise
    end

  private

    def load(options)
      @options = options
      @type = Siba::SibaCheck.options_string(@options, "type")
      @type.downcase!
      @plugin = Siba::PluginLoader.loader.load(category, type, options)
    end
  end
end
