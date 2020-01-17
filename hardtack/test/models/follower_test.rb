require 'test_helper'

class V1::FollowerTest < ActiveSupport::TestCase
  test "get follower" do
    follower_1 = followers(:follower_1)
    assert_not_nil follower_1.follower.nickname
  end
end
