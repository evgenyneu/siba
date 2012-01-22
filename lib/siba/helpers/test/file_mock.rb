# encoding: UTF-8

module SibaTest
  # mocks all Siba::SibaFile methods
  class FileMock
    def method_missing(meth, *args, &block)
      if FileMock.method_defined? meth
        # do nothing
      else
        super
      end
    end

    def respond_to?(meth)
      if FileMock.method_defined? meth
        true
      else
        super
      end
    end

    def self.mock_all_methods
      Siba::FilePlug.siba_file = SibaTest::FileMock.new
    end

    def file_expand_path(file_name)
      file_name
    end

    private

    def self.method_defined?(method_name)
      file_class, method = Siba::SibaFile.get_file_class(method_name)
      return true if !file_class.nil? && file_class.respond_to?(method)
      Siba::SibaFile.instance_methods(false).include? method_name.to_sym
    end
  end
end
