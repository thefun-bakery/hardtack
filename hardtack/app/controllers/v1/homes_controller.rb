class V1::HomesController < ApplicationController
  before_action :set_home, only: [:show, :update, :destroy]

  before_action :validate_authentication, only: [:mine, :update_mine]
  before_action :set_user_by_header, only: [:mine, :update_mine]
  before_action :set_home_by_users_id, only: [:mine, :update_mine]

  # GET /v1/homes
  def index
    @homes = Home.all

    render json: @homes
  end

  # GET /v1/homes/1
  def show
    render json: api_response(@home)
  end

  # POST /v1/homes
  def create
    @home = Home.new(home_params)

    if @home.save
      render json: api_response(@home), status: :created, location: v1_home_url(@home)
    else
      render json: @home.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /v1/homes/1
  def update
    if @home.update(home_params)
      render json: api_response(@home)
    else
      render json: @home.errors, status: :unprocessable_entity
    end
  end

  # DELETE /v1/homes/1
  def destroy
    @home.destroy
  end

  # GET /v1/homes/mine
  def mine
    render json: api_response(@home)
  end

  # PATCH /v1/homes/mine
  def update_mine
    update
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_home
      @home = Home.find(params[:id])
    end

    def set_home_by_users_id
      @home = Home.find_by_users_id(@user.id)
    end

    # Only allow a trusted parameter "white list" through.
    def home_params
      #params.fetch(:v1_home, {})
      params.fetch(:home, {}).permit(:name, :bgcolor)
    end

    def api_response(home)
      home.to_json( :only => [:name, :bgcolor])
    end
end
