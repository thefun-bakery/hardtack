require 'hardtack_file_helper'
require 'json'

class V1::UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  before_action :validate_authentication, only: [:me, :update_me]
  before_action :set_user_by_header, only: [:me, :update_me]


  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /v1/users/1
  def show
    render json: api_response(@user)
  end

  # POST /v1/users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: api_response(@user), status: :created, location: v1_user_url(@user)
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /v1/users/1
  def update
    if @user.update(user_params)
      render json: api_response(@user)
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /v1/users/1
  def destroy
    @user.destroy
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
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      #params.fetch(:user, {})
      params.require(:user).permit!
    end

    def api_response(user)
      response = JSON.parse(user.to_json( :only => [:nickname]))
      response['profile_image_url'] = HardtackFileHelper.get_profile_image_url(
        user.profile_image_filename
      )
      response.to_json
    end
end
