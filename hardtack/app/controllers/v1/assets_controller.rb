require 'json'

class V1::AssetsController < ApplicationController
  before_action :validate_authentication

  # GET /v1/assets/bgcolors
  def bgcolors
    render json: {latest_version: "1.0", bgcolors: ["fefefe", "000000", "ffffff"]}
  end

  # GET /v1/assets/emotions
  def emotions
    file = File.join('assets', 'emotions.json')
    emotions = File.read(file)
    render json: JSON.parse(emotions)
  end

  # GET /v1/assets/emotion-image
  def emotion_image
    file = File.join('assets', 'emotion-image.json')
    emotions = File.read(file)
    render json: JSON.parse(emotions)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
end

