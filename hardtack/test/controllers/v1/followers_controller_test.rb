require 'test_helper'
require 'login'
require 'json'

class V1::FollowersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_1 = users(:user_one)
    @user_2 = users(:user_two)
    @user_3 = users(:user_3)
    @hardtack_token_1 = Login.login(@user_1)
    @hardtack_token_3 = Login.login(@user_3)
  end

  test "should create follower" do
    assert_difference('Follower.count') do
      post v1_followers_url,
        headers: { Authorization: "Bearer #{@hardtack_token_1}" },
        params: { followee_id: @user_3.id },
        as: :json
    end

    assert_response 201
  end

  test "should destroy follower" do
    assert_difference('Follower.count', -1) do
      delete v1_follower_url(@user_1.id),
        headers: { Authorization: "Bearer #{@hardtack_token_3}" },
        as: :json
    end

    assert_response 204
  end
end
