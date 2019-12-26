require 'test_helper'

class HomeTest < ActiveSupport::TestCase
  test "get field" do
    home = homes(:home_one)
    assert_not_nil home.name
    assert_not_nil home.desc
    assert_not_nil home.bgcolor
  end
end
