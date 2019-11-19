require 'error/error_handler'
require 'error/unauthorized_error'
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
end
