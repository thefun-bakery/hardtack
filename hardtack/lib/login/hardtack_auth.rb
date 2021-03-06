require 'error/bad_request_error'

module Login
  module HardtackAuth
    def self.hardtack_access_token_from(authorization_header)
      raise Error::BadRequestError, 'Authorization header is nil' if authorization_header.nil? or authorization_header.empty?
      authorization_header.sub("Bearer ", "")
    end

    def self.cache_key(hardtack_access_token)
      "session:#{hardtack_access_token}"
    end

    def self.is_valid_authorization_header?(authorization_header)
      hardtack_access_token = hardtack_access_token_from(authorization_header)
      is_login?(hardtack_access_token)
    end

    def self.is_login?(hardtack_access_token)
      Rails.cache.exist? cache_key(hardtack_access_token)
    end

    def self.logout?(hardtack_access_token)
      Rails.cache.delete(cache_key(hardtack_access_token)) == 1 ? true : false
    end
  end
end

