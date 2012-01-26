# encoding: UTF-8

module Siba
  class Restore
    include Siba::LoggerPlug
    include Siba::FilePlug
    include Siba::KernelPlug

    def restore(path_to_options_yml)
      run_restore path_to_options_yml
    ensure
      Siba.cleanup
    end

private

    def run_restore(path_to_options_yml)
      LoggerPlug.create "Restore", nil
      options = Siba::OptionsLoader.load_yml path_to_options_yml
      Siba.current_dir = File.dirname path_to_options_yml
      Siba.settings = options["settings"] || {}
      Siba.backup_name = File.basename path_to_options_yml, ".yml"
      TmpDir.test_access 
      tasks = SibaTasks.new options, path_to_options_yml
      file_name = get_backup_choice tasks 
      unless file_name.nil?
        tasks.restore file_name
      else
        logger.finish_success_msg = "Aborted"
      end
      Siba.cleanup_tmp_dir
    rescue Exception => e 
      logger.fatal e
      logger.log_exception e, true
    end

    def get_backup_choice(tasks)
      list = tasks.get_backups_list

      siba_file.run_this do
        list.sort_by!{|a| a[1]}
        siba_kernel.puts "Choose a backup to restore:"
        show_backups list
        get_backup_user_choice list
      end
    end

    def show_backups(list)
      list.map! {|a| a << format_time(a[1])}
      max_date_length = list.max do |a,b|
        a[2].length <=> b[2].length
      end[2].length + 9

      rows = list.size / 2 + list.size % 2
      1.upto(rows) do |i|
        num1 = "#{i.to_s.rjust(2)}."
        str1 = list[i-1][2]
        column1 = sprintf("%s %-#{max_date_length}s", num1, str1)

        if (i+rows) <= list.size
          num2 = "#{(i+rows).to_s.rjust(2)}."
          str2 = list[i+rows-1][2] 
          column2 = "#{num2} #{str2}"
        end
        siba_kernel.puts " #{column1}#{column2}"
      end
    end

    def get_backup_user_choice(list)
      msg = "\nEnter backup number from 1 to #{list.size+1}, or 0 to exit.\n> "
      siba_kernel.printf msg
      while true
        user_choice = siba_kernel.gets.chomp
        number = Integer(user_choice) rescue -1
        if number >= 0 && number <= (list.size + 1)
          return if number == 0
          return list[number-1][0]
        else
          siba_kernel.printf msg
        end 
      end
    end

    def format_time(time)
      time.strftime("%x")
    end
  end
end
