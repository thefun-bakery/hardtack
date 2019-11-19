require 'encryption'
require 'error/user_notfound_error'

class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :validate_authentication, only: [:me, :update_me]

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  # GET /users/me
  def me
    hardtack_access_token = Login::HardtackAuth.hardtack_access_token_from(authorization_header)
    id = Encryption.decrypt(hardtack_access_token)
    user = User.find_by_id(id)
    raise Error::UserNotfoundError if user.nil?
    render json: user
  end

  # POST /users/me
  def update_me
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
end
