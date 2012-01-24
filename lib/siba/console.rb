# encoding: UTF-8

require 'optparse'
require 'siba/scaffold'
require 'siba/generator'

module Siba
  class Console
    include Siba::FilePlug 

    UNUSED_COMMAND = "unused" # unused command for testing command line options
    attr_accessor :test_mode, :parser, :options

    def initialize(test_mode=false)
      @test_mode = test_mode
      @options = {}
    end

    def parse(argv)
      @parser = parse_options argv
      return if parser.nil?
      parse_command argv
    end

  private

    def parse_options(argv)
      parser = OptionParser.new do |o|
        o.banner = "Usage: siba command ARGUMENTS [options...]

Examples: 
    siba backup db.yml          Run backup, reading options from db.yml
    siba generate mybak         Generate mybak.yml options file                        
    siba list                   Show available plugins
    siba scaffold source NAME   Generate new source gem

    Note: single letter commands are supported, like b for backup

Options:"

        o.on("--log FILE", "Set path to log FILE") do |log|
          options['log'] = log
        end
        
        o.on("--no-log", "Work without logging") do 
          SibaLogger.no_log = true
        end

        o.on("-q", "--quiet", "No output to console") do
          SibaLogger.quiet = true
        end

        o.on("-v", "--verbose", "Detailed progress messages and error reports") do
          SibaLogger.verbose = true
        end

        o.on("-h", "--help", "Show this message") do
          show_message o
          return
        end

        o.on("--version", "Show version") do
          show_message "SIBA (SImple BAckup) #{Siba::VERSION}"
          return
        end
      end

      if argv.empty? 
        show_message parser.to_s
        return
      end
      
      begin      
        parser.parse! argv
      rescue Exception => e
        @parser = parser
        show_error e.to_s, e
      end

      if !options['log'].nil? && SibaLogger.no_log
        show_error "ambiguous usage of both --log and --no-log switches"
        return
      end
      
      parser
    end

    def parse_command(argv)
      command = argv.shift
      show_error "missing a command" if command.nil?
      
      case command.downcase
      when "b", "backup"
        backup argv
      when "s", "scaffold"
        scaffold argv
      when "l", "list"
        list
      when "g", "generate"
        generate argv
      when Siba::Console::UNUSED_COMMAND
      else
        show_error "Invalid command '#{command}'"
      end

      exit_with_error if Siba::SibaLogger.count("warn",false) > 0
    end

    def show_error(msg, exception = nil)
      show_message "Error: #{msg}\n\n#{parser.to_s}"
      exit_with_error
      raise (exception || Siba::ConsoleArgumentError.new(msg))
    end

    def show_message(msg)
      puts msg unless test_mode
    end

    def exit_with_error
      exit 1 unless test_mode
    end

    def backup(argv)
      path_to_options = argv.shift
      show_error "missing backup options file argument" if path_to_options.nil?
      show_error "needless arguments: #{argv.join(', ')}" unless argv.empty?
      path_to_options = siba_file.file_expand_path path_to_options
      path_to_log = options['log']

      unless path_to_log.nil?
        path_to_log = siba_file.file_expand_path path_to_log
      else
        log_name = "#{File.basename(path_to_options,".yml")}.log"
        path_to_log = File.join(File.dirname(path_to_options), "#{log_name}")
      end

      Siba::Backup.new.backup path_to_options, path_to_log
    end

    def scaffold(argv)
      category = argv.shift
      if category.nil?
        show_error "missing CATEGORY argument"
      end

      name = argv.shift
      show_error "missing NAME argument" if name.nil?
      show_error "needless arguments: #{argv.join(', ')}" unless argv.empty?

      begin
        Siba::Scaffold.new(category, name).scaffold(siba_file.dir_pwd)
      rescue Exception => ex
        show_error ex
      end
    end

    def list
      show_message "Available SIBA plugins:
      
#{Siba::Plugins.get_list} * Currently installed"
    end

    def generate(argv)
      file = argv.shift
      if file.nil?
        show_error "missing file name"
      end
      Siba::Generator.new(file).generate
    end
  end
end
