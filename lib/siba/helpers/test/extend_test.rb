# encoding: UTF-8

class MiniTest::Unit::TestCase
  include Siba::FilePlug 
  def must_log(level)
    save_logger_state true, level, true
  end

  def wont_log(level)
    save_logger_state false, level, true
  end

  def must_log_from(level)
    save_logger_state true, level, false
  end

  def wont_log_from(level)
    save_logger_state false, level, false
  end

  def verify_log
    log_count_after = Siba::SibaLogger.count log_level, log_exact_level

    if log_exact_level
      message = "'#{log_level}' log messages"
    else
      message = "log messages"
    end

    if log_must_change
      message = "Expected " + message
      raise message if log_count_before == log_count_after
    else
      message = "Unexpected " + message
      raise message if log_count_before != log_count_after
    end
  end

  def mock_file(name, retval, args=[])
    mock = new_mock_file
    mock.expect name, retval, args 
    mock
  end

  def new_mock_file
    Siba::FilePlug.siba_file = MiniTest::Mock.new 
  end

  def show_log
    puts Siba::SibaLogger.messages.map{|a| a.msg}.join("\n")
  end

  def create_plugin(yml_file_name_or_options_hash)
    if yml_file_name_or_options_hash.is_a? String
      load_options yml_file_name_or_options_hash
    else
      @options = yml_file_name_or_options_hash
    end
    
    unless @plugin_name
      raise Siba::Error, "Initialize '@plugin_name' variable ('source', 'destination', etc.)"
    end

    unless @plugin_type
      raise Siba::Error, "Initialize '@plugin_type' variable with your gem type ('cloud', 'ftp' etc)."
    end

    Siba::PluginLoader.loader.load(@plugin_name, @plugin_type, @options)
  end

  def load_options(yml_name)
    unless @yml_path
      raise Siba::Error, "Initialize '@yml_path' variable with the dir to test YAML files."
    end
    @options = SibaTest.load_options File.join(@yml_path, "#{yml_name}.yml")
  end

  def prepare_test_dir(dir_name_part, tmp_dir = nil)
    tmp_dir ||= SibaTest.tmp_dir
    Siba::TestFiles::prepare_test_dir dir_name_part, SibaTest.tmp_dir
  end
  
  def prepare_test_file(file_name_part, tmp_dir = nil)
    tmp_dir ||= SibaTest.tmp_dir
    Siba::TestFiles::prepare_test_file file_name_part, tmp_dir
  end

  def mkdir_in_tmp_dir(prefix)
    Siba::TestFiles::mkdir_in_tmp_dir prefix, SibaTest.tmp_dir
  end

  def dirs_same?(a,b)
    Siba::FileHelper::dirs_same? a, b
  end

  def prepare_options(src_yml_path, replace_data)
    Siba::TestFiles::prepare_options(src_yml_path, replace_data)
  end
  
  def prepare_yml(src_yml_path, replace_data, tmp_dir=nil)
    tmp_dir ||= SibaTest.tmp_dir
    Siba::TestFiles::prepare_yml src_yml_path, replace_data, tmp_dir
  end

  private 

  attr_accessor :log_must_change, :log_level, :log_exact_level, :log_count_before

  def save_logger_state(must_change, level, exact_level = true)
    @log_must_change = must_change
    @log_level = level
    @log_exact_level = exact_level
    @log_count_before = Siba::SibaLogger.count log_level, log_exact_level
  end
end

