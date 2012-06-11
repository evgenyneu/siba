# encoding: UTF-8

require 'securerandom'

module Siba
  class SecurityHelper
    class << self
      def generate_password_for_yaml(length = 16)
        characters = (32..126).to_a - "\\\"".bytes.to_a - "`".bytes.to_a

        (0...length).map{
          characters[SecureRandom.random_number(characters.size)].chr
        }.join
      end

      def alphanumeric_password(length = 16, lowercase_only=false, non_ambiguous = false)
        characters = ('a'..'z').to_a + ('0'..'9').to_a
        characters += ('A'..'Z').to_a unless lowercase_only

        %w{I O l 0 1}.each{ |ambiguous_character|
          characters.delete ambiguous_character
        } if non_ambiguous

        (0...length).map{
          characters[SecureRandom.random_number(characters.size)]
        }.join
      end
    end
  end
end
