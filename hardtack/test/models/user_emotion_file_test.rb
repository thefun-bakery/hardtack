require 'test_helper'

class UserEmotionFileTest < ActiveSupport::TestCase

  test "get field" do
    user_emotion_file = user_emotion_files(:one)
    assert_not_nil user_emotion_file.user_emotion
    assert_not_nil user_emotion_file.file
  end
end

