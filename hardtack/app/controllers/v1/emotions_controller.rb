require 'json'

require 'api_response'
require 'error/bad_request_error'

class V1::EmotionsController < ApplicationController
  before_action :validate_authentication

  before_action :set_emotion, only: [:show, :update, :destroy]
  before_action :set_user_by_header
  before_action :set_home_by_user_id

  before_action :validate_permission, only: [:update, :destroy]


  # GET /v1/homes
  def index
    @emotions = Emotion.all

    render json: @emotions
  end

  # GET /v1/emotions/1
  def show
    render json: ApiResponse.emotion(@emotion)
  end

  # POST /v1/emotions
  def create
    @emotion = Emotion.new(emotion_params)
    @emotion.user_id = @home.user.id
    @emotion.home_id = @home.id

    begin
      ActiveRecord::Base.transaction do
        if @emotion.save
              filename = params[:filename]
              add_file(filename) unless filename.nil?

          render json: ApiResponse.emotion(@emotion), status: :created, location: v1_emotion_url(@emotion)
        else
          render json: @emotion.errors, status: :unprocessable_entity
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
        if @emotion.update(emotion_params)
          filename = params[:filename]
          update_file(filename) unless filename.nil?

          render json: ApiResponse.emotion(@emotion)
        else
          render json: @emotion.errors, status: :unprocessable_entity
        end
      end
    rescue => e
      raise ActiveRecord::Rollback
    end
  end

  # DELETE /v1/emotions/1
  def destroy
    @emotion.destroy
  end

  # GET /v1/emotions/mine
  def mine
    @emotions = Emotion.where(home_id: @home.id).order(created_at: :desc).limit(10)
    render json: ApiResponse.emotion_list(@emotions)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_emotion
      @emotion = Emotion.find(params[:id])
    end

    def set_home_by_user_id
      @home = Home.find_by_user_id(@user.id)
    end

    # Only allow a trusted parameter "white list" through.
    def emotion_params
      params.fetch(:emotion, {}).permit(:emotion_key, :tag)
    end

    def validate_permission
      raise Error::BadRequestError,'permission denied' unless @emotion.user_id == @user.id
    end

    def add_file(filename)
      file = HardtackFile.find_by_name(filename)
      if not file.nil?
        _add_file(@emotion.id, file.id, filename)
      end
    end

    def update_file(filename)
      file = HardtackFile.find_by_name(filename)
      # fileupload를 한개만 한다고 가정한다.
      if not file.nil? and file.id != @emotion.files[0].id
        _add_file(@emotion.id, file.id, filename)
      end
    end

    def _add_file(emotion_id, file_id, filename)
      emotion_file = EmotionFile.new({emotion_id: emotion_id, file_id: file_id})
      raise Error::InternalServerError, "failed to save #{filename}" unless emotion_file.save
    end
end
