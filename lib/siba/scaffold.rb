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
      unless Siba::Plugins.valid_category? category
        raise Siba::Error, "Invalid category '#{category}'. Available categories are: #{Siba::Plugins.categories_str}"
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
        LoggerPlug.create "Scaffolding", nil, false
        logger.debug "Scaffolding started"
        dest_dir = File.join dest_dir, name
        if siba_file.file_directory?(dest_dir) || siba_file.file_file?(dest_dir)
          raise Siba::Error, "Directory already exists #{dest_dir}."
        end

        logger.debug "Checking if GIT is installed"
        raise Siba::Error, "Please install GIT first" unless siba_file.shell_ok? "git help"
        scaffolds_dir = siba_file.file_expand_path "../../../scaffolds", __FILE__

        logger.debug "Creating a tmp dir"
        dest_tmp_dir = Siba::TestFiles.mkdir_in_tmp_dir "scaffold"

        logger.debug "Copying project files"
        project_dir = File.join scaffolds_dir, "project"
        unless siba_file.file_directory? project_dir
          raise Siba::Error, "Scaffold project dir does not exist '#{project_dir}'"
        end
        siba_file.file_utils_cp_r File.join(project_dir,"."), dest_tmp_dir

        logger.debug "Copying init file"
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

        logger.debug "Writing examples to init.rb"
        replace_init_examples scaffolds_dir, init_file_dest

        logger.debug "Setting siba gem dependency"
        replace_siba_version dest_tmp_dir

        logger.debug "Setting gem category and name in file names and contents"
        replace_category_and_name dest_tmp_dir

        gitify dest_tmp_dir

        logger.debug "Copying the project to destination"
        siba_file.file_utils_mkpath dest_dir
        siba_file.file_utils_cp_r File.join(dest_tmp_dir,"."), dest_dir


        logger.info "Project created in #{dest_dir}"
        logger.info "There is a README file with instructions there"
        logger.show_finish_message = false
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
      logger.debug "Initializing GIT repository"
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

    def replace_init_examples(scaffolds_dir, init_file_dest)
      replace_init_example scaffolds_dir, init_file_dest, "init_example.rb"
      replace_init_example scaffolds_dir, init_file_dest, "examples.rb"
    end

    def replace_init_example(scaffolds_dir, init_file_dest, example_file_name)
      shared_dir = siba_file.file_expand_path File.join(scaffolds_dir, "shared")
      init_example_file = File.join shared_dir, example_file_name
      unless siba_file.file_file? init_example_file
        raise Siba::Error, "Can not find init example file: '#{init_example_file}'"
      end
      init_example = Siba::FileHelper.read init_example_file
      Siba::FileHelper.change_file(init_file_dest) do |f|
        replace_text = "## #{example_file_name} ##"
        unless f.include? replace_text
          raise Siba::Error, "Can not replacement text: #{replace_text}"
        end
        f.gsub! replace_text, init_example
      end
    end
  end
end
