# encoding: UTF-8

require 'helper/require_unit' 

describe Siba::SibaTasks do
  before do
    @yml_path = File.expand_path('../../yml/', __FILE__)
  end

  it "should load tasks" do
    create_tasks "valid"
  end


  it "should get tasks" do
    siba_tasks = create_tasks "valid"
    siba_tasks.tasks["source"].must_be_instance_of Siba::SibaTask
  end

  it "should backup on all tasks" do
    create_tasks("valid").backup
  end

  it "should return correct backup name" do
    st = Siba::SibaTasks
    Siba.backup_name = "siba"

    # Monthly backup on the 1st day of each month
    st.backup_name(Time.new 2012, 1,  1).must_equal "siba-month-01"
    st.backup_name(Time.new 2012, 12, 1).must_equal "siba-month-12"

    # Weekly backup on Sunday
    st.backup_name(Time.new 2012, 1,  8).must_equal "siba-week-2-sun"
    st.backup_name(Time.new 2012, 1, 15).must_equal "siba-week-3-sun"
    st.backup_name(Time.new 2012, 1, 22).must_equal "siba-week-4-sun"
    st.backup_name(Time.new 2012, 1, 29).must_equal "siba-week-5-sun"
    st.backup_name(Time.new 2012, 2,  5).must_equal "siba-week-1-sun"
    
    # Daily backup
    st.backup_name(Time.new 2012, 1, 2).must_equal "siba-day-2-mon"
    st.backup_name(Time.new 2012, 1, 3).must_equal "siba-day-3-tue"
    st.backup_name(Time.new 2012, 1, 4).must_equal "siba-day-4-wed"
    st.backup_name(Time.new 2012, 1, 5).must_equal "siba-day-5-thu"
    st.backup_name(Time.new 2012, 1, 6).must_equal "siba-day-6-fri"
    st.backup_name(Time.new 2012, 1, 7).must_equal "siba-day-7-sat"
    st.backup_name(Time.new 2012, 1, 9).must_equal "siba-day-2-mon"

    Siba.backup_name = "cuba"
    st.backup_name(Time.new 2012, 1, 9).must_equal "cuba-day-2-mon"
  end
  
  it "backup name should raise error is Siba.backup_name is not set" do
    st = Siba::SibaTasks
    Siba.backup_name = nil
    ->{st.backup_name(Time.new 2012, 1, 9)}.must_raise Siba::Error

    Siba.backup_name = " "
    ->{st.backup_name(Time.new 2012, 1, 9)}.must_raise Siba::Error
  end

  private

  def create_tasks(yml_file_name)
    options = load_options yml_file_name
    Siba::SibaTasks.new options, File.join(@yml_path, "#{yml_file_name}.yml")
  end
end
