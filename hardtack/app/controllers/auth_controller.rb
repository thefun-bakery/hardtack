require 'login/hardtack_auth'

class AuthController < ApplicationController
  def logout
    hardtack_access_token = request.headers['Authorization']
    render json: {logout: HardtackAuth.logout?(hardtack_access_token)}
  end

  def is_login
    hardtack_access_token = request.headers['Authorization']
    render json: {login: HardtackAuth.is_login?(hardtack_access_token)}
  end
end


