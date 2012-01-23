# encoding: UTF-8

require 'helper/require_integration'
require 'siba-c6y-demo/init'

describe Siba::C6y::Demo::Init do
  it "should run integration test" do
    # All file operations will work normally in integration tests
    # You can use the following helper methods 
    
    # Get path to test tmp dir (will be cleaned automatically after each test)
    SibaTest.tmp_dir
    
    # Make a sub dir with a random name in a test tmp dir
    tmp_sub_dir = mkdir_in_tmp_dir "prefix"

    # Copy the test file to tmp dir (siba/lib/siba/test_files/a_file)
    path_to_test_file = prepare_test_file "prefix"

    # Copy the test dir to tmp dir (siba/lib/siba/test_files/files_and_dirs)
    path_to_test_dir = prepare_test_dir "prefix"
    path_to_test_dir2 = prepare_test_dir "prefix"

    # Compare dirs recursively
    dirs_same? path_to_test_dir, path_to_test_dir2

    # Read test yml and replace values (see siba/test/integration/yml/valid.yml)
    # path_to_options = prepare_options path_to_yml, 
    #                       { src_dir: path_to_test_dir,
    #                         src_file: path_to_test_file,
    #                         dest_dir: path_to_test_dir2 }
  end
end
