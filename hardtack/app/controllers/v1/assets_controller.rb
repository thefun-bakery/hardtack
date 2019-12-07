class V1::AssetsController < ApplicationController
  before_action :validate_authentication

  # GET /v1/assets/bgcolors
  def bgcolors
    render json: {latest_version: "1.0", bgcolors: ["fefefe", "000000", "ffffff"]}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
end

