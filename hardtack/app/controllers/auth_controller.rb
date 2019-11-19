require 'login/hardtack_auth'

class AuthController < ApplicationController
  def logout
    hardtack_access_token = Login::HardtackAuth.hardtack_access_token_from(
      authorization_header
    )
    render json: {logout: Login::HardtackAuth.logout?(hardtack_access_token)}
  end

  def is_login
    hardtack_access_token = Login::HardtackAuth.hardtack_access_token_from(
      authorization_header
    )
    render json: {login: Login::HardtackAuth.is_login?(hardtack_access_token)}
  end
end


