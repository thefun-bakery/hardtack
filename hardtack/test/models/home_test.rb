require 'test_helper'

class HomeTest < ActiveSupport::TestCase
  test "get field" do
    home = Home.find_by_users_id(1)
    assert_not_nil home.name
    assert_not_nil home.desc
    assert_not_nil home.bgcolor
  end
end
