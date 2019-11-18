require 'login/kakao'

class Auth::KakaoController < ApplicationController
  # OAuth /v1/user/login
  def oauth
    code = params['code']
    access_token = Kakao.oauth(code)
    render json: {access_token: access_token}
  end

  def login
    kakao_access_token = request.headers['Authorization']
    access_token = Kakao.login(kakao_access_token)
    render json: {access_token: access_token}
  end
end

