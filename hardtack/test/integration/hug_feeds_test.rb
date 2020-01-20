require 'test_helper'
require 'json'
require 'login'
 
class HugFeedsTest < ActionDispatch::IntegrationTest
  setup do
    @user_1 = users(:user_one)
    @user_3 = users(:user_3)
    @hardtack_token_1 = Login.login(@user_1)
    @hardtack_token_3 = Login.login(@user_3)

    @emotion_3 = emotions(:emotion_three)

    @file_one = hardtack_files(:file_one)
    @file_three = hardtack_files(:file_three)
  end

  test "can feed the emotion hugger" do
    # 1. user_3 현재 hug_feed 수 1
    get v1_hug_feeds_url(page: 0, howmany: 10),
      headers: { Authorization: "Bearer #{@hardtack_token_3}" },
      as: :json
    assert_response :success
    json_response = JSON.parse(@response.body)
    assert_equal(1, json_response.length)

    # 2. user_one 이 등록한 emotion_3 을 user_one이 안아줌
    post v1_emotion_hug_url(@emotion_3),
      headers: { Authorization: "Bearer #{@hardtack_token_1}" },
      as: :json
    assert_response 200
    json_response = JSON.parse(@response.body)
    hug_count = json_response['hug_count']
    assert_equal(1, hug_count)

    # 3. user_3 현재 hug_feed 수 2로 증가
    get v1_hug_feeds_url(page: 0, howmany: 10),
      headers: { Authorization: "Bearer #{@hardtack_token_3}" },
      as: :json
    assert_response :success
    json_response = JSON.parse(@response.body)
    assert_equal(2, json_response.length)

    # 4. 안아주기 취소
    assert_difference('EmotionHugHistory.count', -1) do
      delete v1_emotion_hug_url(@emotion_3),
        headers: { Authorization: "Bearer #{@hardtack_token_1}" },
        as: :json
    end

    # 5. user_3 현재 hug_feed 수 1로 감소 
    get v1_hug_feeds_url(page: 0, howmany: 10),
      headers: { Authorization: "Bearer #{@hardtack_token_3}" },
      as: :json
    assert_response :success
    json_response = JSON.parse(@response.body)
    assert_equal(1, json_response.length)
  end
end
