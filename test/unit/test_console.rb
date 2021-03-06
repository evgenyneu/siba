# encoding: UTF-8

require 'helper/require_unit'

describe Siba::Console do
  before do
    @console = Siba::Console.new true
    @yml_path = File.expand_path('../yml', __FILE__)
    @path_to_yml = File.join @yml_path, "valid.yml"
    @unused = Siba::Console::UNUSED_COMMAND
    Siba::LoggerPlug.close
    Siba::SibaLogger.quiet = true
    Siba::SibaLogger.no_log = true
  end

  it "should parse console command" do
    @console.parse ["-h"]
    @console.parse ["-help"]
    @console.parse ["--version"]
  end

  it "should accept quiet mode with q" do
    Siba::SibaLogger.quiet = false
    @console.parse [@unused, "-q"]
    Siba::SibaLogger.quiet.must_equal true
  end

  it "should accept quiet mode with quiet" do
    Siba::SibaLogger.quiet = false
    @console.parse [@unused, "--quiet"]
    Siba::SibaLogger.quiet.must_equal true
  end

  it "should accept verbose mode with v" do
    Siba::SibaLogger.verbose = false
    @console.parse [@unused, "-v"]
    Siba::SibaLogger.verbose.must_equal true
  end

  it "should accept quiet mode with quiet" do
    Siba::SibaLogger.verbose = false
    @console.parse [@unused, "--verbose"]
    Siba::SibaLogger.verbose.must_equal true
  end

  it "should accept log switch" do
    Siba::SibaLogger.no_log = false
    @console.parse [@unused, "--log=/test"]
    @console.options["log"].must_equal "/test"
  end

  it "should accept no-log switch" do
    Siba::SibaLogger.no_log = false
    @console.parse [@unused, "--no-log"]
    Siba::SibaLogger.no_log.must_equal true
  end

  it "should accept cur switch" do
    @console.options["cur"].must_be_nil
    @console.parse [@unused, "--current-source"]
    @console.options["cur"].must_equal true
  end

  it "should fail when using both log and no-log" do
    Siba::SibaLogger.no_log = false
    ->{@console.parse [@unused, "--no-log", "--log=test"]}.must_raise Siba::ConsoleArgumentError
  end

  it "should fail when arguments are invalid" do
    ->{@console.parse ["-unknown"]}.must_raise OptionParser::InvalidOption
  end

  it "should fail when invalid command" do
    ->{@console.parse ["invalid"]}.must_raise Siba::ConsoleArgumentError
  end

  it "should fail when missing a command" do
    ->{@console.parse ["-v"]}.must_raise Siba::ConsoleArgumentError
  end

  it "should show no errors with not arguments" do
    @console.parse []
  end

  describe "when run backup command" do
    it "should run b command" do
      @console.parse ["b", @path_to_yml]
      wont_log_from "warn"
    end

    it "should run backup command" do
      @console.parse ["backup", @path_to_yml]
      wont_log_from "warn"
    end

    it "should fail when backup options file is missing" do
      ->{@console.parse ["backup"]}.must_raise Siba::ConsoleArgumentError
    end

    it "should fail when needless arguments are specified" do
      ->{@console.parse ["backup", "one", "two"]}.must_raise Siba::ConsoleArgumentError
    end
  end

  describe "when run scaffold commend" do
    it "should run b command" do
      @console.parse ["s", "source", "myname"]
    end

    it "should run backup command" do
      @console.parse ["scaffold", "destination", "myname"]
    end

    it "scaffold should fail when category is missing" do
      ->{@console.parse ["s"]}.must_raise Siba::ConsoleArgumentError
    end

    it "scaffold should fail when category is incorrect" do
      ->{@console.parse ["s", "incorrect"]}.must_raise Siba::ConsoleArgumentError
    end

    it "scaffold should fail when name is missing" do
      ->{@console.parse ["s", "destination"]}.must_raise Siba::ConsoleArgumentError
    end

    it "should fail when needless arguments are specified" do
      ->{@console.parse ["s", "source", "name", "needless"]}.must_raise Siba::ConsoleArgumentError
    end
  end

  describe "when run list commend" do
    it "should run l command" do
      @console.parse ["l"]
    end

    it "should run list command" do
      @console.parse ["list"]
    end
  end

  describe "when run generate commend" do
    it "should run g command" do
      @console.parse ["g", "myfile"]
    end

    it "should run generate command" do
      @console.parse ["generate", "myfile"]
    end

    it "should fail if file name is missing" do
      ->{@console.parse ["g"]}.must_raise Siba::ConsoleArgumentError
    end
  end

  describe "when run restore command" do
    it "should run r command" do
      @console.parse ["r", @path_to_yml]
    end

    it "should run restore command" do
      @console.parse ["restore", @path_to_yml]
    end

    it "should fail when backup options file is missing" do
      ->{@console.parse ["restore"]}.must_raise Siba::ConsoleArgumentError
    end

    it "should fail when needless arguments are specified" do
      ->{@console.parse ["restore", "one", "two"]}.must_raise Siba::ConsoleArgumentError
    end
  end
end
