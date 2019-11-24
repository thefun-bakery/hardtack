module Error
  class InternalServerError < BaseError
    def initialize(_message)
      super(:internal_server_error, 500, _message)
    end
  end
end
