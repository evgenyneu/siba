# encoding: UTF-8

require 'helper/require_unit'
require 'siba/plugins/source/files/init'

describe Siba::Source::Files do
  before do
    @yml_path = File.expand_path('../yml', __FILE__)
    @plugin_category="source"
    @plugin_type="files"
  end

  it "should call path_match?" do
    Siba::Source::Files::Files.path_match? "file", "include"
  end

  it "must match path" do
    match_list = [
      # ----------------------
      # compare basenames
      ["file",    "/file"],
      # sub-dirs
      ["file",    "/dir/dir/file"],
      ["file.ext", "/dir/dir/file.ext"],
      # white space
      ["file",    " /file "],
      [" file ",  "/file"],
      # case
      ["file",    "/FILE"],
      ["FILE",    "/file"],

      # ----------------------
      # match basenames against pattern
      ["*.tmp",   "/file.tmp"],
      ["*.jpg",   "/.hidden.jpg"],
      ["*.tmp",   "/dir/file.tmp"],
      [".*",      "/.hidden"],
      [".*",      "/dir/.hidden"],
      [".*",      "/dir/dir/.hidden"],
      # white space
      [" *.tmp ", "/file.tmp"],
      ["*.tmp",   " /file.tmp "],
      # case
      ["*.TMP",   "/file.tmp"],
      ["*.tmp",   "/File.TMP "],

      # ----------------------
      # match whole path against pattern
      ["/root/dir1/file",   "/root/dir1/file"],
      ["/.*",       "/.hidden/file"],
      ["*/file",    "/dir/file"],
      ["*file",     "/file"],
      ["*file",     "/dir/file"],
      ["**file",    "/dir/file"],
      ["**/file",   "/root/dir/file"],
      ["/file*",    "/file"],
      ["/file*",    "/file_one"],
      ["/file*",    "/file_one/two"],
      ["/file*",    "/file_one/two/three"],
      ["/file**",   "/file"],
      ["/file**",   "/file_one"],
      ["/file**",   "/file_one/two"],
      ["/file**",   "/file_one/two/three"],
      ["/dir/*",    "/dir/two/three"],
      ["**/dir/**", "/root/one/dir/two/file"],
      ["*",         "/name"],
      ["*",         "/dir1/dir2/file"],
      ["**",        "/dir1/dir2/file"],
      ["/*",        "/name"],
      ["/*",        "/name/another"],
      # white space
      [" **/dir/** ", "/root/one/dir/two/file"],
      ["**/dir/**",   " /root/one/dir/two/file "],
      # case
      [" **/DIR/** ", "/root/one/dir/two/file"],
      ["**/dir/**",   "/ROOT/ONE/DIR/TWO/FILE"],
    ]

    match_list.each do |item|
      pattern = item[0]
      file = item[1]
      unless Siba::Source::Files::Files.path_match?(pattern, file)
        flunk "'#{pattern}' pattern must match '#{file}' path"
      end
    end
  end

  it "must NOT match" do
    must_not_match_list = [
      # ----------------------
      # compare basenames
      ["file",    "/somefile"],
      ["file",    "/.file"],
      ["file",    "/file/somefile"],
      ["file",    "/file/file/somefile"],
      ["file",    "/file_file"],
      ["file",    "/file_file/.file"],
      ["file",    "/file.ext"],
      ["ext",     "/file.ext"],
      [".ext",    "/file.ext"],

      # ----------------------
      # match basenames against pattern
      ["name*",   "/somename"],

      # ----------------------
      # match whole path against pattern
      [".*",      "/.hidden/file"],
      ["*.ext",   "/dir/name.ext/file"],
      ["*name",   "/dir1/dir2/name/file"],
      ["dir",     "/dir1/dir/file"],
      ["dir",     "/dir/name/file"],
      ["dir/name",  "/name"],
      ["dir/name",  "/root/dir/name"],
      ["/file*",    "/root/file"],
      ["/file/*",   "/file"],
    ]

    must_not_match_list.each do |item|
      pattern = item[0]
      file = item[1]
      if Siba::Source::Files::Files.path_match?(pattern, file)
        flunk "'#{pattern}' pattern must NOT match '#{file}' path"
      end
    end
  end

  it "ingored? should be false with no ignore data" do
    create_plugin("no_ignore").files.ignored?("file").must_equal false
  end

  it "ingored? should respect ignore list" do
    task = create_plugin("ignore_list").files
    task.ignored?("/file").must_equal false
    task.ignored?("/file1").must_equal true
    task.ignored?("/file2").must_equal true
    task.ignored?("/.hidden").must_equal true
    task.ignored?("/dir/file").must_equal false
  end
end
