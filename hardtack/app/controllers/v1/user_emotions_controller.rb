require 'json'

require 'api_response'
#require 'hardtack_file_helper'
require 'error/bad_request_error'

class V1::UserEmotionsController < ApplicationController
  before_action :validate_authentication

  before_action :set_user_emotion, only: [:show, :update, :destroy]
  before_action :set_user_by_header
  before_action :set_home_by_user_id

  before_action :validate_permission, only: [:update, :destroy]


  # GET /v1/homes
  def index
    @user_emotions = UserEmotion.all

    render json: @user_emotions
  end

  # GET /v1/user-emotions/1
  def show
#    emotion_map = load_emotion_map
    render json: ApiResponse.emotion(@user_emotion)
  end

  # POST /v1/emotions
  def create
    @user_emotion = UserEmotion.new(user_emotion_params)
    @user_emotion.user_id = @home.user.id
    @user_emotion.home_id = @home.id

    begin
      ActiveRecord::Base.transaction do
        if @user_emotion.save
              filename = params[:filename]
              add_file(filename) unless filename.nil?

              #emotion_map = load_emotion_map
          render json: ApiResponse.emotion(@user_emotion), status: :created, location: v1_user_emotion_url(@user_emotion)
        else
          render json: @user_emotion.errors, status: :unprocessable_entity
        end
      end
    rescue => e
      raise ActiveRecord::Rollback
    end
  end

  # PATCH/PUT /v1/emotions/1
  def update
    begin
      ActiveRecord::Base.transaction do
        if @user_emotion.update(user_emotion_params)
          filename = params[:filename]
          update_file(filename) unless filename.nil?

          #emotion_map = load_emotion_map
          render json: ApiResponse.emotion(@user_emotion)
        else
          render json: @user_emotion.errors, status: :unprocessable_entity
        end
      end
    rescue => e
      raise ActiveRecord::Rollback
    end
  end

  # DELETE /v1/emotions/1
  def destroy
    @user_emotion.destroy
  end

  # GET /v1/emotions/mine
  def mine
    #emotion_map = load_emotion_map
    @user_emotions = UserEmotion.where(home_id: @home.id).order(created_at: :desc).limit(10)
    render json: ApiResponse.emotion_list(@user_emotions)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_emotion
      @user_emotion = UserEmotion.find(params[:id])
    end

    def set_home_by_user_id
      @home = Home.find_by_user_id(@user.id)
    end

    # Only allow a trusted parameter "white list" through.
    def user_emotion_params
      params.fetch(:user_emotion, {}).permit(:emotion_key, :tag)
    end

    def validate_permission
      raise Error::BadRequestError,'permission denied' unless @user_emotion.user_id == @user.id
    end

    def add_file(filename)
      file = HardtackFile.find_by_name(filename)
      if not file.nil?
        _add_file(@user_emotion.id, file.id, filename)
      end
    end

    def update_file(filename)
      file = HardtackFile.find_by_name(filename)
      # fileupload를 한개만 한다고 가정한다.
      if not file.nil? and file.id != @user_emotion.files[0].id
        _add_file(@user_emotion.id, file.id, filename)
      end
    end

    def _add_file(user_emotion_id, file_id, filename)
      user_emotion_file = UserEmotionFile.new({user_emotion_id: user_emotion_id, file_id: file_id})
      raise Error::InternalServerError, "failed to save #{filename}" unless user_emotion_file.save
    end
end
