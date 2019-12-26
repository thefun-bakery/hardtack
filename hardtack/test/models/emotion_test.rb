require 'test_helper'

class EmotionTest < ActiveSupport::TestCase
  test "get field" do
    emotion = emotions(:emotion_one)
    assert_not_nil emotion.emotion_key
    assert_not_nil emotion.tag
    assert_not_nil emotion.files
  end
end

