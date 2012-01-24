# encoding: UTF-8

module Siba
  # Password strength calculator based on: 
  #   http://snippets.dzone.com/posts/show/4698
  #   https://www.grc.com/haystack.htm
  class PasswordStrength 
    PASSWORD_SETS = {
      /[a-z]/ => 26,
      /[A-Z]/ => 26,
      /[0-9]/ => 10,
      /[^\w]/ => 33
    }

    AinB = {
      second: 60,
      minute: 60,
      hour: 24,
      day: 30,
      month: 12,
      year: 100,
      century: 1
    }

    Illions = {
      hundred: 100,
      thousand: 10,
      million: 1000,
      billion: 1000,
      trillion: 1000
    }

    TRIES_PER_SECOND = 100 * 10 ** 12 # 100 TFLOPS
    AGE_OF_THE_UNIVERSE_SECONDS = 4.336 * 10 ** 17 # the best estimate on 2011

    class << self
      def seconds_to_crack(password)
        set_size = 0
        PASSWORD_SETS.each_pair {|k,v| set_size += v if password =~ k}
        combinations = 0
        1.upto(password.length) {|i| combinations += set_size ** i }
        combinations.to_f / TRIES_PER_SECOND
      end

      # Password is considered weak if it takes less than a year to crack it
      def is_weak?(seconds_to_crack)
        seconds_to_crack < 60 * 60 * 24 * 365
      end

      # Convert the number of seconds human-friendly timespan string
      # Example: 
      #   130: 2 minutes
      #   12345: 3 hours
      def seconds_to_timespan(seconds)
        return "forever" if seconds > AGE_OF_THE_UNIVERSE_SECONDS
        ticks = seconds
        AinB.each_pair do |a,b|
          ticks_next = ticks.to_f / b
          return get_timespan_str ticks, a if ticks_next < 1
          ticks = ticks_next
        end

        # century or longer
        ticks = ticks.floor
        return get_timespan_str ticks, "century", "centuries" if ticks < 100
        illion_unit, ticks = get_illions ticks
        "#{ticks} #{illion_unit} centuries".strip
      end

      private

      def get_timespan_str(ticks, unit, unit_plural=nil)
        ticks = ticks.floor
        return case
          when ticks < 1 then "less than a #{unit}"
          when ticks == 1 then "1 #{unit}"
          else "#{ticks} #{unit_plural || unit.to_s+"s"}"
        end
      end

      def get_illions(ticks)
        illion_unit = ""
        Illions.each_pair do |a,b|
          ticks_next = ticks.to_f / b
          break if ticks_next < 1 
          illion_unit = a 
          ticks = ticks_next
        end

        return illion_unit, ticks.floor
      end
    end
  end
end
