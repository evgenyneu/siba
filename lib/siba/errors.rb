# encoding: UTF-8

module Siba
  class Error < RuntimeError; end
  class PluginLoadError < RuntimeError; end
  class CheckError < RuntimeError; end
  class ConsoleArgumentError < RuntimeError; end
end
