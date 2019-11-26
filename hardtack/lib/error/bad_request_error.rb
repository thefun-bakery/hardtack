require 'error/base_error'

module Error
  class BadRequestError < BaseError
    def initialize(_message)
      super(:bad_request, 400, _message)
    end
  end
end
