require 'test_helper'
require 'json'

require 'login'

class V1::EmotionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @emotion = emotions(:emotion_one)
    @hardtack_token = Login.login(@emotion.home.user)

    @emotion_two = emotions(:emotion_two)

    @file_one = hardtack_files(:file_one)
    @file_three = hardtack_files(:file_three)
  end

  test "should create v1_emotion" do
    assert_difference('Emotion.count') do
      post v1_emotions_url,
        params: {
          emotion_key: 'thefun_bakery:default:hug:hug',
          tag: '#tag1',
          filename: @file_one.name
        },
        headers: { Authorization: "Bearer #{@hardtack_token}" },
        as: :json
    end

    assert_response 201
  end

  test "should show v1_emotion" do
    get v1_emotion_url(@emotion),
      headers: { Authorization: "Bearer #{@hardtack_token}" },
      as: :json
    assert_response :success
  end

  test "should show v1_emotions_mine" do
    get v1_emotions_mine_url,
      headers: { Authorization: "Bearer #{@hardtack_token}" },
      as: :json
    assert_response :success
    json_response = JSON.parse(@response.body)
    assert_not_equal(0, json_response.length)
  end

  test "should update v1_emotion" do
    patch v1_emotion_url(@emotion),
      params: {
        tag: '#updated1, #updated2',
        filename: @file_three.name
      },
      headers: { Authorization: "Bearer #{@hardtack_token}" },
      as: :json
    assert_response 200
  end

  test "should destroy v1_emotion" do
    assert_difference('Emotion.count', -1) do
      delete v1_emotion_url(@emotion),
        headers: { Authorization: "Bearer #{@hardtack_token}" },
        as: :json
    end

    assert_response 204
  end

  test "should fail update v1_emotion with different_user" do
    patch v1_emotion_url(@emotion_two),
      params: { emotion_params: {tag: '#updated1, #updated2'} },
      headers: { Authorization: "Bearer #{@hardtack_token}" },
      as: :json
    assert_response 400
  end
end
