# encoding: UTF-8

require 'helper/require_unit'

describe Siba::OptionsLoader do
  before do
    @yml_path = File.expand_path('../yml/options_loader', __FILE__)
  end

  it 'should load yml' do
    load_options "valid"
    @options.must_be_instance_of Hash
  end

  it 'should load hash from yml' do
    hash = Siba::OptionsLoader.load_hash_from_yml File.join(@yml_path, "valid.yml")
    hash.must_be_instance_of Hash
  end

  it 'should load erb' do
    data = Siba::OptionsLoader.load_erb File.join(@yml_path, "valid.yml")
    data.must_be_instance_of String
    data.wont_be_empty
  end

  it 'should render erb template' do
    load_options "valid"
    @options["erb"].must_equal 4
  end

  it 'should fail if options file does not have yml extension' do
    path = File.join @yml_path, "file_without_yml_extension"
    -> { Siba::OptionsLoader.load_yml(path) }.must_raise Siba::Error
  end

  it 'should fail to load missing file' do
    -> { load_options "missing" }.must_raise Siba::Error
  end

  it 'should fail to load invalid yml' do
    -> { load_options "invalid" }.must_raise Siba::Error
  end

  it 'should fail to load empty yml' do
    -> { load_options "empty" }.must_raise Siba::Error
  end

  it 'should fail to to yml with a string' do
    -> { load_options "string" }.must_raise Siba::Error
  end

  it 'should fail to load yml with array' do
    -> { load_options "array" }.must_raise Siba::Error
  end

  it 'should load yml with bom' do
    options = load_options("utf8_with_bom")
    options["key"].must_equal "value"
  end
end
