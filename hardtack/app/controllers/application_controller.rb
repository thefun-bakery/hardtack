require 'encryption'
require 'error/error_handler'
require 'error/unauthorized_error'
require 'error/user_notfound_error'
require 'login/hardtack_auth'

class ApplicationController < ActionController::API
  include Error::ErrorHandler
  include Login::HardtackAuth


  protected

  def validate_authentication
    raise Error::UnauthorizedError unless Login::HardtackAuth.is_valid_authorization_header?(authorization_header)
  end

  def authorization_header
    request.headers['Authorization']
  end

  def set_user_by_header
    hardtack_access_token = Login::HardtackAuth.hardtack_access_token_from(
      authorization_header
    )
    id = Encryption.decrypt(hardtack_access_token)
    @user = User.find(id)
    raise Error::UserNotfoundError if @user.nil?
  end
end
