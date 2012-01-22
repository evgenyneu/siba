# encoding: UTF-8

module Siba
  class Scaffold
    include Siba::FilePlug
    include Siba::LoggerPlug
    attr_accessor :category, :name, :name_camelized
    CATEGORY_REPLACE_TEXT = "c6y"
    NAME_REPLACE_TEXT = "demo"
    
    def initialize(category, name)
      @category = category
      unless Siba::Plugin.valid_category? category
        raise Siba::Error, "Invalid category '#{category}'. Available categories are: #{Siba::Plugin.categories_str}"
      end

      @name = Siba::StringHelper.str_to_alphnumeric name
      raise Siba::Error, "first character of gem name can not be number" if name =~ /^[0-9]/

      @name_camelized = StringHelper.camelize name
    end

    def scaffold(dest_dir)
      run_scaffold dest_dir
    ensure
      Siba.cleanup
    end

    private

    def run_scaffold(dest_dir)
      siba_file.run_this "scaffold" do
        LoggerPlug.create "Scaffolding", nil
        raise Siba::Error, "Please install GIT first" unless siba_file.shell_ok? "git help"
        scaffolds_dir = siba_file.file_expand_path "../../../scaffolds", __FILE__
        
        # create a tmp file where we will generace the project
        dest_tmp_dir = Siba::TestFiles.mkdir_in_tmp_dir "scaffold"

        # Copy project files (which are the same for all plugin categories)
        project_dir = File.join scaffolds_dir, "project"
        unless siba_file.file_directory? project_dir
          raise Siba::Error, "Scaffold project dir does not exist '#{project_dir}'"
        end
        siba_file.file_utils_cp_r File.join(project_dir,"."), dest_tmp_dir
        
        # Copy init file (different for each plugin category)
        init_file = File.join scaffolds_dir, "#{category}.rb"
        unless siba_file.file_file? init_file
          raise Siba::Error, "Scaffold init file does not exist '#{init_file}'"
        end
        init_dir = File.join dest_tmp_dir, "lib", "siba-#{CATEGORY_REPLACE_TEXT}-demo"  
        unless siba_file.file_directory? init_dir
          raise Siba::Error, "Source dir does not exist '#{init_dir}'"
        end
        init_file_dest = File.join init_dir,"init.rb"
        siba_file.file_utils_cp init_file, init_file_dest 
        unless siba_file.file_file? init_file_dest
          raise Siba::Error, "Filed to create init file '#{init_file_dest}'"
        end

        replace_siba_version dest_tmp_dir

        # Replace "cy6" with category, and "demo" with name
        replace_category_and_name dest_tmp_dir        

        gitify dest_tmp_dir
       
        # Finally, copy the project to destination
        dest_dir = File.join dest_dir, name
        siba_file.file_utils_mkpath dest_dir
        siba_file.file_utils_cp_r File.join(dest_tmp_dir,"."), dest_dir
      end
    rescue Exception => e 
      logger.fatal e
      logger.log_exception e, true
    end

    def replace_category_and_name(dir)
      Siba::FileHelper.entries(dir).each do |entry|
        entry_path = replace_path dir, entry
        if siba_file.file_directory? entry_path
          replace_category_and_name entry_path 
        else
          replace_file_contents entry_path
        end
      end
    end

    def replace_path(dir, entry)
      entry_path = File.join dir, entry
      entry_after = entry.gsub CATEGORY_REPLACE_TEXT, category 
      entry_after = entry_after.gsub NAME_REPLACE_TEXT, name 
      if entry_after != entry
        entry_path_after = File.join(dir, entry_after)
        siba_file.file_utils_mv entry_path, entry_path_after
        entry_path = entry_path_after
      end
      entry_path
    end

    def replace_file_contents(path_to_file)
      return unless siba_file.file_file? path_to_file
      Siba::FileHelper.change_file(path_to_file) do |file_text|
        file_text.gsub! CATEGORY_REPLACE_TEXT, category 
        file_text.gsub! CATEGORY_REPLACE_TEXT.capitalize, category.capitalize
        file_text.gsub! NAME_REPLACE_TEXT, name 
        file_text.gsub! NAME_REPLACE_TEXT.capitalize, name_camelized 
        file_text
      end
    end

    def gitify(path_to_project)
      siba_file.file_utils_cd path_to_project
      siba_file.run_shell "git init", "Failed to init git repository"
      siba_file.run_shell "git add ."
      siba_file.run_shell "git commit -a -m 'Initial commit'"
    end

    def replace_siba_version(project_dir)
      path_to_gemspec = File.join project_dir, "siba-c6y-demo.gemspec"
      raise Siba::Error, "Can not find gemspec file #{path_to_gemspec}" unless siba_file.file_file? path_to_gemspec
      Siba::FileHelper.change_file(path_to_gemspec) do |file_text|
        version = Siba::VERSION.split('.')[0..-2].join('.')
        file_text.gsub "siba_version", version 
      end
    end
  end
end
