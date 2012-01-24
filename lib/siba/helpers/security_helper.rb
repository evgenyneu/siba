# encoding: UTF-8
 
require 'securerandom'

module Siba
  class SecurityHelper
    class << self
      def generate_password(length = 16)
        (0...length).map{      
          (SecureRandom.random_number(95)+32).chr
        }.join                 
      end
    end   
  end
end
