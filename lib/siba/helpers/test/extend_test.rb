# encoding: UTF-8

class MiniTest::Unit::TestCase
  include Siba::FilePlug 
  def must_log(level)
    verify_log true, level, true
  end

  def wont_log(level)
    verify_log false, level, true
  end

  def must_log_from(level)
    verify_log true, level, false
  end

  def wont_log_from(level)
    verify_log false, level, false
  end

  def show_log
    puts Siba::SibaLogger.messages.map{|a| a.msg}.join("\n")
  end

  def mock_file(name, retval, args=[])
    mock = new_mock_file
    mock.expect name, retval, args 
    mock
  end

  def new_mock_file
    Siba::FilePlug.siba_file = MiniTest::Mock.new 
  end

  def create_plugin(yml_file_name_or_options_hash)
    if yml_file_name_or_options_hash.is_a? String
      load_options yml_file_name_or_options_hash
    else
      @options = yml_file_name_or_options_hash
    end
    
    unless @plugin_category
      raise Siba::Error, "Initialize '@plugin_category' variable (#{Siba::Plugins.categories_str})"
    end

    unless @plugin_type
      raise Siba::Error, "Initialize '@plugin_type' variable with your gem name ('cloud', 'ftp' etc)."
    end

    Siba::PluginLoader.loader.load(@plugin_category, @plugin_type, @options)
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

  def verify_log(must_change, log_level, exact_level = true)
    log_count = Siba::SibaLogger.count log_level, exact_level

    if exact_level
      message = "'#{log_level}' log messages"
    else
      message = "log messages"
    end

    if must_change
      message = "Expected " + message
      raise message if log_count == 0
    else
      message = "Unexpected " + message
      raise message if log_count > 0
    end
  end
end

