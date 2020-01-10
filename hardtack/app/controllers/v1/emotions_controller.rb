require 'json'

require 'api_response'
require 'error/bad_request_error'

class V1::EmotionsController < ApplicationController
  before_action :validate_authentication

  before_action :set_emotion, only: [:show, :update, :destroy]
  before_action :set_user_by_header
  before_action :set_home_by_user_id

  before_action :validate_permission, only: [:update, :destroy]


  # GET /v1/emotions
  def index
    home_id = params[:home].to_i
    page = params[:page].to_i
    counts = [[params[:counts].to_i, 10].max, 100].min # 최소 10, 최대 100개로 조정.

    offset = page * counts 
    limit = counts + 1

    field_selection = home_id == 0 ? {} : {home_id: home_id}
    @emotions = Emotion.where(field_selection)
      .offset(offset)
      .limit(limit)
      .order('id desc')

    render json: ApiResponse.emotion_list(@emotions, @user)
  end

  # GET /v1/emotions/1
  def show
    render json: ApiResponse.emotion(@emotion, @user)
  end

  # POST /v1/emotions/:id/hug
  def hug
    id = params[:id].to_i
    @emotion = Emotion.find_by_id(id)

    # 내가 나를 안아주는건 안해준다.
    raise Error::BadRequestError, "can't hug self" if @emotion.user_id == @user.id

    emotion_hug_count = nil
    ActiveRecord::Base.transaction do
      emotion_hug_count = plus_hug_count
      log_hug
    end

    render json: emotion_hug_count
  end

  # DELETE /v1/emotions/:id/hug
  def unhug
    id = params[:id].to_i
    @emotion = Emotion.find_by_id(id)

    # 내가 나를 안안아주는건 안해준다.
    raise Error::BadRequestError, "can't unhug self" if @emotion.user_id == @user.id

    emotion_hug_count = nil
    ActiveRecord::Base.transaction do
      emotion_hug_count = minus_hug_count
      unlog_hug
    end

    render json: emotion_hug_count
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

          render json: ApiResponse.emotion(@emotion, @user), status: :created, location: v1_emotion_url(@emotion)
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

          render json: ApiResponse.emotion(@emotion, @user)
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
    #@emotions = Emotion.where(home_id: @home.id).order(created_at: :desc).limit(10)

    page = params[:page].to_i
    counts = [[params[:counts].to_i, 10].max, 100].min # 최소 10, 최대 100개로 조정.

    offset = page * counts
    limit = counts + 1

    field_selection = {home_id: @home.id}
    @emotions = Emotion.where(field_selection)
      .offset(offset)
      .limit(limit)
      .order('id desc')
    render json: ApiResponse.emotion_list(@emotions, @user)
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

    def plus_hug_count
      if @emotion.emotion_hug_count.nil?
        EmotionHugCount.create(emotion: @emotion)
      else
        @emotion.emotion_hug_count.hug_count += 1
        @emotion.emotion_hug_count.save!
        return @emotion.emotion_hug_count
      end
    end

    def minus_hug_count
      if @emotion.emotion_hug_count.nil?
        raise Error::BadRequestError,'no hug count'
      else
        @emotion.emotion_hug_count.hug_count -= 1
        @emotion.emotion_hug_count.save!
        return @emotion.emotion_hug_count
      end
    end

    def log_hug
      begin
        EmotionHugHistory.create({emotion: @emotion, user: @user})
      rescue ActiveRecord::RecordNotUnique => e
        raise Error::BadRequestError,'already hugged'
      end
    end

    def unlog_hug
      emotion_hug_history = EmotionHugHistory.find_by_emotion_id_and_user_id(@emotion, @user)
      if emotion_hug_history.nil?
        raise Error::BadRequestError,'no hug history'
      else
        emotion_hug_history.delete
      end
    end
end
