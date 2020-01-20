require 'test_helper'

class HugFeedTest < ActiveSupport::TestCase
  test "get field" do
    hug_feed = hug_feeds(:hug_feed_1)
    assert_not_nil hug_feed.follower
    assert_not_nil hug_feed.emotion
    assert_not_nil hug_feed.hugger
  end
end
