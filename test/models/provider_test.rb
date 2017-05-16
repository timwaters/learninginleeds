require 'test_helper'

class ProviderTest < ActiveSupport::TestCase
  test "should not save venue without name" do
    provider = Provider.new
    assert_not provider.save
  end
end
