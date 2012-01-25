# encoding: UTF-8

module Siba
  class SibaKernel
    undef_method :puts
    def method_missing(meth, *args, &block)
      if Kernel.respond_to? meth
        Kernel.send meth, *args, &block
      else
        super
      end
    end

    def respond_to?(meth)
      if Kernel.respond_to? meth
        true
      else
        super
      end
    end
  end

  module KernelPlug
    def siba_kernel
      KernelPlug.siba_kernel
    end

    def self.siba_kernel
      @siba_kernel ||= Siba::SibaKernel.new
    end

    # It is used in test to insert mock SibaKernel object
    def self.siba_kernel=(val)
      @siba_kernel = val
    end
  end
end
