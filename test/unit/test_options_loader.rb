# encoding: UTF-8

require 'helper/require_unit' 

class OptionsLoaderTest < MiniTest::Unit::TestCase
  def setup
    @yml_path = File.expand_path('../yml/options_loader', __FILE__)
  end

  def test_load_yml
    load_options "valid"
    assert_instance_of Hash, @options
  end

  def test_load_hash_from_yml
    hash = Siba::OptionsLoader.load_hash_from_yml File.join(@yml_path, "valid.yml")
    assert_instance_of Hash, hash
  end
  
  def test_load_erb
    data = Siba::OptionsLoader.load_erb File.join(@yml_path, "valid.yml")
    assert_instance_of String, data
    refute_empty data 
  end

  def test_load_yml_check_erb
    load_options "valid"
    assert_equal 4, @options["erb"]
  end

  def test_should_fail_if_options_file_does_not_have_yml_extension
    path = File.join @yml_path, "file_without_yml_extension"
    assert_raises(Siba::Error) do
      Siba::OptionsLoader.load_yml(path)
    end
  end

  def test_load_file_missing
    assert_raises(Siba::Error) do
      load_options "missing"
    end
  end

  def test_load_invalid_yml
    assert_raises(Siba::Error) do
      load_options "invalid"
    end
  end

  def test_should_not_load_empty_yml
    assert_raises(Siba::Error) do
      load_options "empty"
    end
  end

  def test_should_not_load_yml_with_string
    assert_raises(Siba::Error) do
      load_options "string"
    end
  end

  def test_should_not_load_yml_with_array
    assert_raises(Siba::Error) do
      load_options "array"
    end
  end

  def test_load_yml_with_bom
    options = load_options("utf8_with_bom")
    assert_equal options["key"], "value"
  end
end
