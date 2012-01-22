# encoding: UTF-8

require 'helper/require_unit'
require 'siba/helpers/password_strength'

describe Siba::PasswordStrength do
  before do
    @ps = Siba::PasswordStrength
  end

  it "should run seconds_to_crack" do
    Siba::PasswordStrength.seconds_to_crack("Pass123$").round(2).must_equal 67.05
  end
  
  it "runs seconds_to_crack with a very long password" do
    Siba::PasswordStrength.seconds_to_crack("very lonG p@asswoRd very lonG p@asswoRd very lonG p@asswoRd 
very lonG p@asswoRd very lonG p@asswoRd very lonG p@asswoRd very lonG p@asswoRd very lonG p@asswoRd 
very lonG p@asswoRd very lonG p@asswoRd very lonG p@asswoRd very lonG p@asswoRd very lonG p@asswoRd 
very lonG p@asswoRd very lonG p@asswoRd very lonG p@asswoRd very lonG p@asswoRd very lonG p@asswoRd 
very lonG p@asswoRd very lonG p@asswoRd very lonG p@asswoRd very lonG p@asswoRd very lonG p@asswoRd 
very lonG p@asswoRd very lonG p@asswoRd very lonG p@asswoRd very lonG p@asswoRd very lonG p@asswoRd 
very lonG p@asswoRd very lonG p@asswoRd very lonG p@asswoRd very lonG p@asswoRd very lonG p@asswoRd 
very lonG p@asswoRd very lonG p@asswoRd very lonG p@asswoRd very lonG p@asswoRd very lonG p@asswoRd 
very lonG p@asswoRd very lonG p@asswoRd very lonG p@asswoRd very lonG p@asswoRd very lonG p@asswoRd 
very lonG p@asswoRd very lonG p@asswoRd very lonG p@asswoRd very lonG p@asswoRd very lonG p@asswoRd 
very lonG p@asswoRd very lonG p@asswoRd very lonG p@asswoRd very lonG p@asswoRd very lonG p@asswoRd").must_equal Float::INFINITY
  end

  it "should run in_weak?" do
    Siba::PasswordStrength.is_weak?(10).must_equal true
    Siba::PasswordStrength.is_weak?(60*60*24).must_equal true
    Siba::PasswordStrength.is_weak?(60*60*24*365).must_equal false
    Siba::PasswordStrength.is_weak?(1000*60*60*24*365).must_equal false
    Siba::PasswordStrength.is_weak?(Float::INFINITY).must_equal false
  end

  it "should run seconds_to_timespan" do
    two_cents = 200 * 365 * 86400
    thousand = 1000 
    million = 1000 * 1000
    billion = 1000 * 1000 * 1000 
    
    valid_strings = [
      [0.2, "less than a second"],
      [0.5, "less than a second"],
      [1, "1 second"],
      [2, "2 seconds"],
      [59, "59 seconds"],
      [60, "1 minute"],
      [80, "1 minute"],
      [110, "1 minute"],
      [3599, "59 minutes"],
      [3600, "1 hour"],
      [43202, "12 hours"],
      [86403, "1 day"],
      [1209606, "14 days"],
      [2592000, "1 month"],
      [8592000, "3 months"],
      [365 * 86400, "1 year"],
      [14 * 365 * 86400, "14 years"],
      [100 * 365 * 86400, "1 century"],
      [two_cents, "2 centuries"],
      [100 * 100 * 365 * 86400, "1 hundred centuries"],
      [100 * two_cents, "2 hundred centuries"],
      [thousand * two_cents, "2 thousand centuries"],
      [10 * thousand * two_cents, "20 thousand centuries"],
      [million * two_cents, "2 million centuries"],
      [billion * two_cents, "forever"],
      [Float::INFINITY, "forever"]
    ]

    valid_strings.each do |a|
      Siba::PasswordStrength.seconds_to_timespan(a[0]).must_equal a[1]
    end
  end
end
