# encoding: UTF-8

module Siba
  class Scaffold
    include Siba::FilePlug
    attr_accessor :category, :name
    
    def initialize(category, name)
      @category = category
      unless Siba::Plugin.valid_category? category
        raise Siba::Error, "Invalid category '#{category}'. Available categories are: #{Siba::Plugin.categories_str}"
      end

      @name = Siba::StringHelper.str_to_alphnumeric name
      raise Siba::Error, "first character of gem name can not be number" if name =~ /^[0-9]/
    end

    def scaffold(dest_dir)
      siba_file.run_this "scaffold" do
        src_dir = siba_file.file_expand_path "../../../scaffolds", __FILE__  
        src_dir = File.join src_dir, category
        puts "Src dir: #{src_dir}"
        raise Siba::Error, "No scaffolds for '#{category}'" unless siba_file.file_directory? src_dir
        dest_tmp_dir = Siba::TestFiles.mkdir_in_tmp_dir "scaffold"
        siba_file.file_utils_cp_r src_dir, dest_tmp_dir
        #replace demo with name
        siba_file.file_utils_cp_r dest_tmp_dir, dest_dir
      end
    end
  end
end
