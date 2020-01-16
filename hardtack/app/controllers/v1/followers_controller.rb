require 'hardtack_file_helper'
require 'json'

class V1::FollowersController < ApplicationController
  before_action :validate_authentication
  before_action :set_user_by_header


  # GET /v1/follower/1
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

  # GET /v1/users/me
  def me
    render json: api_response(@user)
  end

  # POST /v1/users/me
  def update_me
    update
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
end
