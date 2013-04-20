module SibaMinitestPlugin
  def before_setup
    super
    SibaTest.setup_hooks.each { |hook| hook.call }
  end

  def after_teardown
    SibaTest.teardown_hooks.each { |hook| hook.call }
    super
  end
end

class MiniTest::Unit::TestCase
  include SibaMinitestPlugin
end