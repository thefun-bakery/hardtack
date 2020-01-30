require 'test_helper'
require 'login'
require 'json'

class V1::MainControllerTest < ActionDispatch::IntegrationTest
  setup do
    @v1_home_one = homes(:home_one)
    @v1_home_two = homes(:home_two)
    @v1_home_no_visit_count_and_visit_log \
      = homes(:home_no_visit_count_and_visit_log)
    @hardtack_token = Login.login(@v1_home_one.user)
    @hardtack_token_3 = Login.login(users(:user_3))
  end

  test "should show v1_main/mine" do
    get v1_main_mine_url,
      headers: { Authorization: "Bearer #{@hardtack_token}" },
      as: :json
    assert_response :success

    json_response = JSON.parse(@response.body)
    assert_equal(true, json_response['is_owner'])
    assert_equal(false, json_response['user']['is_friend'])
  end

  test "should show v1_main/1" do
    get v1_main_url(home_id: @v1_home_one.id),
      headers: { Authorization: "Bearer #{@hardtack_token}" },
      as: :json
    assert_response :success

    json_response = JSON.parse(@response.body)
    assert_equal(true, json_response['is_owner'])
    assert_equal(false, json_response['user']['is_friend'])
  end

  test "should show v1_main/2 visit others home not friend" do
    get v1_main_url(home_id: @v1_home_two.id),
      headers: { Authorization: "Bearer #{@hardtack_token}" },
      as: :json
    assert_response :success

    json_response = JSON.parse(@response.body)
    assert_equal(false, json_response['is_owner'])
    assert_equal(false, json_response['user']['is_friend'])
  end


  test "should show v1_main/2 visit others home and friend" do
    get v1_main_url(home_id: @v1_home_two.id),
      headers: { Authorization: "Bearer #{@hardtack_token_3}" },
      as: :json
    assert_response :success

    json_response = JSON.parse(@response.body)
    assert_equal(false, json_response['is_owner'])
    assert_equal(true, json_response['user']['is_friend'])
  end

  test "should show v1_main/3" do
    get v1_main_url(home_id: @v1_home_no_visit_count_and_visit_log.id),
      headers: { Authorization: "Bearer #{@hardtack_token}" },
      as: :json
    assert_response :success

    # check result
    result = JSON.parse(@response.body)
    assert_not_nil result['emotion']
    assert_equal result['home']['visit_count'], 0
    assert_equal result['emotion']['hug_count'], 0
  end
end
