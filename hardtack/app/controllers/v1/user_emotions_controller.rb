require 'hardtack_file_helper'
require 'error/bad_request_error'
require 'json'

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
    emotion_map = load_emotion_map
    render json: api_response(@user_emotion, emotion_map)
  end

  # POST /v1/homes
  def create
    @user_emotion = UserEmotion.new(user_emotion_params)
    @user_emotion.user_id = @home.user.id
    @user_emotion.home_id = @home.id

    if @user_emotion.save
      filename = params[:filename]
      add_file(filename) unless filename.nil?

      emotion_map = load_emotion_map
      render json: api_response(@user_emotion, emotion_map), status: :created, location: v1_user_emotion_url(@user_emotion)
    else
      render json: @user_emotion.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /v1/homes/1
  def update
    if @user_emotion.update(user_emotion_params)
      filename = params[:filename]
      update_file(filename) unless filename.nil?

      emotion_map = load_emotion_map
      render json: api_response(@user_emotion, emotion_map)
    else
      render json: @user_emotion.errors, status: :unprocessable_entity
    end
  end

  # DELETE /v1/homes/1
  def destroy
    @user_emotion.destroy
  end

  # GET /v1/homes/mine
  def mine
    emotion_map = load_emotion_map
    @user_emotions = UserEmotion.where(home_id: @home.id).order(created_at: :desc).limit(10)
    render json: api_list_response(@user_emotions, emotion_map)
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

    def get_emotion_map(emotions)
      result = {}
      for emotion in emotions do
        images = emotion['images']
        for image in images do
          key = image['key']
          svg = image['svg']
          lottie = image['lottie']
          result[key] = {svg: svg, lottie: lottie}
        end
      end

      result
    end
    
    def load_emotion_map
      # TODO emotion mapping을 매번 파일에서 읽고 있는데, 이건 별도로 분리하자
      file = File.join('assets', 'emotion-image.json')
      str_emotions = File.read(file)
      emotions = JSON.parse(str_emotions)
      get_emotion_map(emotions)
    end

    def api_response(user_emotion, emotion_map)
      # NOTE, 이용자 파일의 무조건 첫번째 이미지만 취급한다.
      {
        id: user_emotion.id,
        emotion: user_emotion.emotion_key,
        emotion_url: emotion_map[user_emotion.emotion_key],
        tag: user_emotion.tag,
        user_image_url: HardtackFileHelper.get_download_url(user_emotion.files[0]),
        created_at: user_emotion.created_at,
        updated_at: user_emotion.updated_at
      }
    end

    def api_list_response(user_emotions, emotion_map)
      result = []
      for user_emotion in user_emotions do
        result.push(api_response(user_emotion, emotion_map))
      end
      result
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
