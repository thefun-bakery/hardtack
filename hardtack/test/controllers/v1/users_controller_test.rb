require 'test_helper'

class V1::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should get index" do
    get v1_users_url, as: :json
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post v1_users_url, params: { user: { nickname: 'sammy', service: 'kakao', identifier: 100 } }, as: :json
    end

    assert_response 201
  end

  test "should show user" do
    get v1_user_url(@user), as: :json
    assert_response :success
  end

  test "should update user" do
    patch v1_user_url(@user), params: { user: { nickname: 'updated_nick', service: 'kakao', identifier: 100  } }, as: :json
    assert_response 200
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete v1_user_url(@user), as: :json
    end

    assert_response 204
  end

  test "should show me" do
    auth_header = login(@user)
    get v1_users_me_url(@user), headers: {Authorization: auth_header}, as: :json
    assert_response :success
  end

  test "should update me" do
    auth_header = login(@user)
    patch(
      v1_users_me_url(@user),
      params: { user: { nickname: 'updated_nick'} },
      headers: {Authorization: auth_header},
      as: :json
    )
    assert_response :success
  end
end
