# encoding: UTF-8

require 'helper/require_unit' 

describe Siba::SibaTask do
  before do
    @yml_path = File.expand_path('../yml/task', __FILE__)
  end

  it "should load task with NO sub-tasks" do
    wont_log "error"
    task_category = "archive"
    options = load_options "valid"
    new_task = Siba::SibaTask.new options, task_category
    new_task.wont_be_nil 
    new_task.plugin.wont_be_nil
    new_task.category.must_equal task_category
    new_task.type.must_equal "tar"
    new_task.options.must_equal options[task_category]
    verify_log
  end

  it "should raise errors" do
    options = load_options "valid"
    ->{Siba::SibaTask.new options, "unknown"}.must_raise Siba::CheckError

    options = load_options "invalid"
    ->{Siba::SibaTask.new options, "invalid"}.must_raise Siba::CheckError
    ->{Siba::SibaTask.new options, "archive"}.must_raise Siba::PluginLoadError
  end
end
