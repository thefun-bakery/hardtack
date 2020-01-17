require 'json'

require 'api_response'
require 'error/bad_request_error'

class V1::FeedsController < ApplicationController
  before_action :validate_authentication
  before_action :set_user_by_header


  # GET /v1/feeds
  def index
    page = params[:page].to_i
    counts = [[params[:counts].to_i, 10].max, 100].min # 최소 10, 최대 100개로 조정.

    offset = page * counts 
    limit = counts + 1

    field_selection = {follower_id: @user.id}
    @feeds = Feed.where(field_selection)
      .offset(offset)
      .limit(limit)
      .order('id desc')

    render json: ApiResponse.feed_list(@feeds, @user)
  end
#
#  # GET /v1/emotions/1
#  def show
#    render json: ApiResponse.emotion(@emotion, @user)
#  end
#
#  # DELETE /v1/emotions/1
#  def destroy
#    @emotion.destroy
#  end


private

end
