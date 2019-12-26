require 'test_helper'

class UserEmotionTest < ActiveSupport::TestCase
  test "get field" do
    user_emotion = user_emotions(:user_emotion_one)
    assert_not_nil user_emotion.emotion_key
    assert_not_nil user_emotion.tag
    assert_not_nil user_emotion.files
  end
end

