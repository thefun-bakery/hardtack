require 'fog'

class V1::FilesController < ApplicationController
  before_action :validate_authentication, only: [:new, :show]
  before_action :set_user_by_header, only: [:new, :show]
  before_action :set_home_by_users_id, only: [:new, :show]

  TIME_TO_ACCESS        = 2.seconds
  AWS_ACCESS_KEY_ID     = Rails.application.credentials.aws[:access_key_id]
  AWS_SECRET_ACCESS_KEY = Rails.application.credentials.aws[:secret_access_key]
  REGION                = Rails.application.credentials.aws[:region]
  #BUCKET                = Rails.application.credentials.aws[:bucket]
  BUCKET                = 'temp'

  # GET /v1/files?filename=xxx
  def show
    download_url = client.get_object_url(
      BUCKET,
      params.fetch(:filename),
      TIME_TO_ACCESS.from_now.to_i
    )

    render json: {
      download_url: download_url
    }
  end

  # POST /v1/files
  def new
    upload_url = client.put_object_url(
      BUCKET,
      params.fetch(:filename),
      TIME_TO_ACCESS.from_now.to_i
    )

    render json: {
      upload_url: upload_url
    }
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_home_by_users_id
      @home = Home.find_by_users_id(@user.id)
    end

    def client
      @client ||= Fog::Storage::AWS.new({
        aws_access_key_id: AWS_ACCESS_KEY_ID,
        aws_secret_access_key: AWS_SECRET_ACCESS_KEY,
        region: REGION 
      })
    end
end

