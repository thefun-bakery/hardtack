require 'error/base_error'

module Error
  class UnauthorizedError < BaseError
    def initialize
      super(:unauthorized, 401, 'access-token is invalid or expired.')
    end
  end
end
