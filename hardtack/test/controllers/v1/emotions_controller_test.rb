require 'test_helper'
require 'json'

require 'login'

class V1::EmotionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @emotion = emotions(:emotion_one)
    @hardtack_token = Login.login(@emotion.home.user)

    @emotion_two = emotions(:emotion_two)
    @emotion_no_hug = emotions(:emotion_no_hug)

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

  test "emotions paging - page:0" do
    #get v1_emotions_url(home: @emotion.home.id, offset: 3, howmany: 10),
    get v1_emotions_url,
      headers: { Authorization: "Bearer #{@hardtack_token}" },
      as: :json
    assert_response 200

    result = JSON.parse(@response.body)
    assert_equal(11, result.size)
  end

  test "emotions paging - page:last" do
    get v1_emotions_url(home: @emotion.home.id, page: 1, howmany: 10),
      headers: { Authorization: "Bearer #{@hardtack_token}" },
      as: :json
    assert_response 200

    result = JSON.parse(@response.body)
    assert_equal(2, result.size)
  end

  test "emotions paging - page:out_of_last" do
    get v1_emotions_url(home: @emotion.home.id, page: 2),
      headers: { Authorization: "Bearer #{@hardtack_token}" },
      as: :json
    assert_response 200

    result = JSON.parse(@response.body)
    assert_equal(0, result.size)
  end


  test "emotions hug self" do
    post v1_emotion_hug_url(@emotion),
      headers: { Authorization: "Bearer #{@hardtack_token}" },
      as: :json
    assert_response 400
  end


  test "emotions hug" do
    post v1_emotion_hug_url(@emotion_no_hug),
      headers: { Authorization: "Bearer #{@hardtack_token}" },
      as: :json
    assert_response 200

    result = JSON.parse(@response.body)
    assert_equal(1, result['hug_count'])

    # 이미 hug 했는데 또 하려고 할 때.
    post v1_emotion_hug_url(@emotion_no_hug),
      headers: { Authorization: "Bearer #{@hardtack_token}" },
      as: :json
    assert_response 400
    assert_equal 1, EmotionHugCount.find_by_emotion_id(@emotion_no_hug.id).hug_count
  end


  test "emotions hug emotion already hugged by another user" do
    post v1_emotion_hug_url(@emotion_two),
      headers: { Authorization: "Bearer #{@hardtack_token}" },
      as: :json
    assert_response 200

    result = JSON.parse(@response.body)
    assert_equal(2, result['hug_count'])
    assert_equal 2, EmotionHugHistory.all.length
  end


  test "emotions unhug self" do
    post v1_emotion_hug_url(@emotion),
      headers: { Authorization: "Bearer #{@hardtack_token}" },
      as: :json
    assert_response 400
  end


  test "emotions unhug" do
    post v1_emotion_hug_url(@emotion_two),
      headers: { Authorization: "Bearer #{@hardtack_token}" },
      as: :json
    assert_response 200

    # hug 한것을 다시 unhug 한다.
    delete v1_emotion_unhug_url(@emotion_two),
      headers: { Authorization: "Bearer #{@hardtack_token}" },
      as: :json
    assert_response 200
    result = JSON.parse(@response.body)
    assert_equal 1, result['hug_count']
    assert_equal 1, EmotionHugHistory.all.length
  end


  test "emotions unhug empty count" do
    delete v1_emotion_unhug_url(@emotion_no_hug),
      headers: { Authorization: "Bearer #{@hardtack_token}" },
      as: :json
    assert_response 400
  end
end
