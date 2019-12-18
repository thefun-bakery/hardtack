require 'hardtack_file_helper'

class V1::FilesController < ApplicationController
  before_action :validate_authentication, only: [:prepare_upload, :show]
  before_action :set_user_by_header, only: [:prepare_upload]
  before_action :set_home_by_users_id, only: [:prepare_upload]


  # GET /v1/files?filename=xxx
  def show
    filename = get_filename_from_params(params)
    url = HardtackFileHelper.get_download_url(filename)
    Rails.logger.debug(url)

    render json: {
      url: url
    }
  end

  # POST /v1/files
  def prepare_upload
    filename, url = HardtackFileHelper.prepare_upload(@user)
    Rails.logger.debug(url)

    render json: {
      filename: filename,
      url: url
    }
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_home_by_users_id
      @home = Home.find_by_user_id(@user.id)
    end

    def file_params
      params.fetch(:file, {}).permit(:name, :upload_complete)
    end

    def get_filename_from_params(params)
      case params.has_key? :format
      when true
        "#{params.fetch(:filename)}.#{params.fetch(:format)}" 
      when false
        "#{params.fetch(:filename)}"
      end
    end

    def api_response(file)
      file.to_json( :only => [:name])
    end
end

