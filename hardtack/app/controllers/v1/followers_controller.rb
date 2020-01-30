require 'hardtack_file_helper'
require 'json'
require 'api_response'

class V1::FollowersController < ApplicationController
  before_action :validate_authentication
  before_action :set_user_by_header

  # GET /v1/followers
  # header상의 user 기준 follower 목록 추출
  def index
    page = params[:page].to_i
    counts = [[params[:counts].to_i, 10].max, 100].min # 최소 10, 최대 100개로 조정.

    offset = page * counts 
    limit = counts + 1

    field_selection = {followee_id: @user.id}
    @followers = Follower.where(field_selection)
      .offset(offset)
      .limit(limit)
      .order('id desc')

    render json: followers_list(@followers)
  end

  # GET /v1/followers/followee
  # header상의 user 기준 followee 목록 추출
  def followees 
    page = params[:page].to_i
    counts = [[params[:counts].to_i, 10].max, 100].min # 최소 10, 최대 100개로 조정.

    offset = page * counts 
    limit = counts + 1

    field_selection = {follower_id: @user.id}
    @followees = Follower.where(field_selection)
      .offset(offset)
      .limit(limit)
      .order('id desc')

    render json: followees_list(@followees)
  end

  # GET /v1/followers/1
  # id는 followers 테이블 primary key. 즉 user_id 와 관계가 없는 그냥 pkey다.
  # create 후의 결과를 보여주기 위한 용도.
  def show
    render json: api_response(@follower)
  end

  # POST /v1/followers
  def create
    @follower = Follower.new(followee_id: follower_params[:followee_id], follower_id: @user.id )

    if @follower.save
      render json: api_response(@follower), status: :created, location: v1_follower_url(@follower)
    else
      render json: @follower.errors, status: :unprocessable_entity
    end
  end

  # DELETE /v1/users/1
  def destroy
    followee_id = params[:id].to_i
    @follower = Follower.find_by_followee_id_and_follower_id(followee_id, @user.id)
    @follower.destroy unless @follower.nil?
  end

  private

    # Only allow a trusted parameter "white list" through.
    def follower_params
      params.require(:follower).permit(:followee_id)
    end

    def api_response(follower)
      response = JSON.parse(follower.to_json( :only => [:followee_id, :follower_id]))
      response.to_json
    end

    def followers_list(follow_info_list)
      response = []
      for follow_info in follow_info_list
        # TODO, 성능개선. 속도가 느리지만 일단 이렇게 처리한다.
        user = User.find_by_id(follow_info.follower_id)
        user_info = ApiResponse.user_info(user)
        user_info[:added_at] = follow_info.created_at
        response.push(user_info)
      end
      response.to_json
    end

    def followees_list(follow_info_list)
      response = []
      for follow_info in follow_info_list
        # TODO, 성능개선. 속도가 느리지만 일단 이렇게 처리한다.
        user = User.find_by_id(follow_info.followee_id)
        user_info = ApiResponse.user_info(user)
        user_info[:added_at] = follow_info.created_at
        response.push(user_info)
      end
      response.to_json
    end
end
