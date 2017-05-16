require 'test_helper'

class VenueTest < ActiveSupport::TestCase

  test "should not save venue without name" do
    venue = Venue.new
    assert_not venue.save
  end

  test "should not save venue without a postcode" do
    venue = Venue.new
    assert_not venue.save
  end

end
