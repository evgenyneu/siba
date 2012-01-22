# encoding: UTF-8

require 'helper/require_unit'

describe Siba::LogMessage do
  before do
    @message = Siba::LogMessage.new
  end

  it "should contain level" do
    @message.level = 2
    @message.level.must_equal 2
  end

  it "should contain time" do
    time = Time.now
    @message.time = time
    @message.time.must_equal time
  end
  
  it "should contain msg" do
    msg = "hey"
    @message.msg = msg
    @message.msg.must_equal msg
  end
end
