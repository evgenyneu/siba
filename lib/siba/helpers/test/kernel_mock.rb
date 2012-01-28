# encoding: UTF-8

module SibaTest
  # mocks all Siba::SibaKernel methods
  class KernelMock
    undef_method :puts
    def method_missing(meth, *args, &block)
      if KernelMock.method_defined? meth
        # do nothing
      else
        super
      end
    end

    def respond_to?(meth)
      if KernelMock.method_defined? meth
        true
      else
        super
      end
    end


    class << self
      # the valud 'siba_kernel.gets' method will return
      attr_accessor :gets_return_value

      def mock_all_methods
        Siba::KernelPlug.siba_kernel = SibaTest::KernelMock.new
        SibaTest::KernelMock.gets_return_value = nil
      end
    end

    def gets(*args)
      SibaTest::KernelMock.gets_return_value
    end

    private

    def self.method_defined?(method_name)
      return Kernel.respond_to? method_name
    end
  end
end
