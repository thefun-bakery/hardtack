require 'api_response'

class V1::MainController < ApplicationController
  before_action :validate_authentication, only: [:mine, :show]

  before_action :set_user_by_header, only: [:mine, :show]
  before_action :set_home_by_user_id, only: [:mine, :show]
  before_action :set_main, only: [:mine, :show]

  # GET /v1/main/1
  def show
    render json: ApiResponse.main(@main)
  end

  # GET /v1/main/mine
  def mine
    render json: ApiResponse.main(@main)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_main
      # 가장 최근의 감정을 불러온다.
      @emotion = Emotion.order(created_at: :desc).where(user_id: @home.user_id).first
      @main = Main.new(
        home: @home,
        emotion: @emotion
      )
    end

    def set_home_by_user_id
      @home = Home.find_by_user_id(@user.id)
    end
end
