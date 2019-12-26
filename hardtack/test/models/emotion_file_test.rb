require 'test_helper'

class EmotionFileTest < ActiveSupport::TestCase

  test "get field" do
    emotion_file = emotion_files(:emotion_file_one)
    assert_not_nil emotion_file.emotion
    assert_not_nil emotion_file.file
  end
end

