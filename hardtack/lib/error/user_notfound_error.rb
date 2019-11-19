module Error
  class UserNotfoundError < BaseError
    def initialize
      super(:user_not_found, 404, 'not exist.')
    end
  end
end
