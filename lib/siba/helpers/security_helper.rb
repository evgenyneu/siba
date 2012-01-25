# encoding: UTF-8
 
require 'securerandom'

module Siba
  class SecurityHelper
    class << self
      def generate_password_for_yaml(length = 16)
        characters = (32..126).to_a - "\\\"".bytes.to_a

        (0...length).map{      
          characters[SecureRandom.random_number(characters.size)].chr
        }.join                 
      end
    end   
  end
end
