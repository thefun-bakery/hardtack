require 'api_response'

class V1::MainController < ApplicationController
  before_action :validate_authentication, only: [:mine, :show]

  before_action :set_user_by_header, only: [:mine, :show]
  before_action :set_home_by_user_id, only: [:mine]
  before_action :set_main, only: [:mine]

  after_action :count_visit_home, only: [:show]
  after_action :log_visit_home, only: [:show]

  # GET /v1/main/:home_id
  def show
    set_main_by_home_id(params[:home_id])
    render json: ApiResponse.main(@main, @user).compact
  end

  # GET /v1/main/mine
  def mine
    render json: ApiResponse.main(@main, @user).compact
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

    def set_main_by_home_id(home_id)
      @home = Home.find_by_id(home_id)
      set_main
    end

    def count_visit_home
      # 방문수를 늘리고.
      # 내가 내 집을 방문한것은 카운트 하지 않는다.
      return if @user.id == @home.user.id

      if @home.home_visit_count.nil?
        HomeVisitCount.create(home: @home)
      else
        @home.home_visit_count.visit_count += 1
        @home.home_visit_count.save!
      end
    end

    def log_visit_home
      # 방문 정보를 기록한다.
      # 내가 내 집을 방문한것은 기록 하지 않는다.
      return if @user.id == @home.user.id
      HomeVisitHistory.create(home: @home, user: @user)
    end
end
