require 'test_helper'
require 'json'
require 'login'
 
class FeedTest < ActionDispatch::IntegrationTest
  setup do
    @user_1 = users(:user_one)
    @user_3 = users(:user_3)
    @hardtack_token_1 = Login.login(@user_1)
    @hardtack_token_3 = Login.login(@user_3)

    @file_one = hardtack_files(:file_one)
    @file_three = hardtack_files(:file_three)
  end

  test "can feed the emotion" do
    # 1. user_3 현재 feed 수 2
    get v1_feeds_url(page: 0, howmany: 10),
      headers: { Authorization: "Bearer #{@hardtack_token_3}" },
      as: :json
    assert_response :success
    json_response = JSON.parse(@response.body)
    assert_equal(2, json_response.length)

    # 2. user_one 감정 등록
    post v1_emotions_url,
      params: {
        emotion_key: 'thefun_bakery:default:hug:hug',
        tag: '#tag1',
        filename: @file_one.name
      },
      headers: { Authorization: "Bearer #{@hardtack_token_1}" },
      as: :json
    assert_response 201
    json_response = JSON.parse(@response.body)
    emotion_id = json_response['id']
    emotion = Emotion.find(emotion_id)

    # 3. user_3 현재 feed 수 3으로 증가
    get v1_feeds_url(page: 0, howmany: 10),
      headers: { Authorization: "Bearer #{@hardtack_token_3}" },
      as: :json
    assert_response :success
    json_response = JSON.parse(@response.body)
    assert_equal(3, json_response.length)

    # 4. 감정 삭제
    assert_difference('Emotion.count', -1) do
      delete v1_emotion_url(emotion),
        headers: { Authorization: "Bearer #{@hardtack_token_1}" },
        as: :json
    end

    # 5. user_3 현재 feed 수 2로 감소 
    get v1_feeds_url(page: 0, howmany: 10),
      headers: { Authorization: "Bearer #{@hardtack_token_3}" },
      as: :json
    assert_response :success
    json_response = JSON.parse(@response.body)
    assert_equal(2, json_response.length)
  end
end
