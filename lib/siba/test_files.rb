# encoding: UTF-8

module Siba::TestFiles
  class << self
    include Siba::FilePlug
    def test_files_dir
      siba_file.file_expand_path("../test_files/", __FILE__)
    end

    def test_file
      File.join test_files_dir, "a_file"
    end    

    def test_dir
      File.join test_files_dir, "files_and_dirs"
    end    

    def prepare_test_dir(dest_dir_name_part, tmp_dir=nil)
      tmp_dir ||= Siba.tmp_dir
      dest_dir = File.join(tmp_dir,"td-#{dest_dir_name_part}#{random_suffix}")
      siba_file.file_utils_mkpath tmp_dir unless siba_file.file_directory? tmp_dir
      siba_file.file_utils_cp_r test_dir, dest_dir
      dest_dir
    end
    
    def prepare_test_file(dest_file_name_part, tmp_dir=nil)
      tmp_dir ||= Siba.tmp_dir
      dest_file = File.join(tmp_dir,"tf-#{dest_file_name_part}#{random_suffix}")
      siba_file.file_utils_mkpath tmp_dir unless siba_file.file_directory? tmp_dir
      siba_file.file_utils_cp test_file, dest_file
      dest_file
    end

    def generate_path(dest_file_name_part, tmp_dir=nil)
      tmp_dir ||= Siba.tmp_dir
      File.join(tmp_dir,"tf-#{dest_file_name_part}#{random_suffix}")
    end  

    def mkdir_in_tmp_dir(prefix, tmp_dir=nil)
      tmp_dir ||= Siba.tmp_dir
      dir = "test-#{prefix}#{random_suffix}"
      dir_path = File.join(tmp_dir, dir)
      siba_file.file_utils_mkpath dir_path
      dir_path
    end

    def prepare_options_text(src_yml_path, replace_data)
      replace_prefix = "#_replace_"
      options_text = Siba::FileHelper.read src_yml_path
      replace_data.each_pair do |key, value|
        str_to_replace = "#{replace_prefix}#{key.to_s}"
        raise "YML does not contain #{str_to_replace} text" unless options_text.include? str_to_replace
        options_text.gsub! str_to_replace, value
      end

      raise "Test YML still has unreplaced text" if options_text.include? "#{replace_prefix}"
      options_text
    end

    def prepare_options(src_yml_path, replace_data)
      YAML.load prepare_options_text(src_yml_path, replace_data)
    end

    def prepare_yml(src_yml_path, replace_data, tmp_dir=nil)
      tmp_dir ||= Siba.tmp_dir
      options_text = prepare_options_text src_yml_path, replace_data
      dest_file = File.join tmp_dir,"#{File.basename(src_yml_path,".yml")}#{random_suffix}.yml"
      siba_file.file_open(dest_file, "w") { |f| f.write options_text }
      dest_file
    end

    def random_suffix
      "-#{rand(1000000)}-#{rand(1000000)}"
    end
  end
end
