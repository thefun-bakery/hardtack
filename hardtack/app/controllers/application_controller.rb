require 'error/error_handler'
require 'login/hardtack_auth'

class ApplicationController < ActionController::API
  include Error::ErrorHandler
  include Login::HardtackAuth
end
