require 'rest-client'
require 'json'

require 'encryption'
require 'login/services'
require 'login/hardtack_auth'
require 'error/bad_request_error'

module Login
  module Kakao
    REDIRECT_URI = Rails.application.credentials.hardtack[:auth][:kakao][:redirect_uri]
    CLIENT_ID = Rails.application.credentials.hardtack[:auth][:kakao][:client_id]


    def self.get_access_token(code)
      res = RestClient.post('https://kauth.kakao.com/oauth/token',
                            {
                              grant_type: 'authorization_code',
                              client_id: CLIENT_ID,
                              redirect_uri: REDIRECT_URI,
                              code: code
                            }
                           )

      json_res = JSON.parse(res.body)
      json_res['access_token']
    end


    def self.get_me(access_token)
      begin
        res = RestClient.post('https://kapi.kakao.com/v2/user/me',
                              {},
                              headers={Authorization: access_token}
                             )
      rescue => e
        raise Error::BadRequestError, 'invalid access-token' if e.http_code == 401
        raise e
      end

      json_res = JSON.parse(res.body)
      id = json_res['id']
      nickname = json_res['properties']['nickname']

      return id, nickname
    end


    def self.oauth(code)
      access_token = get_access_token(code)
      login(access_token)
    end

    def self.login(kakao_access_token)
      raise Error::BadRequestError, 'Authorization header is nil' if kakao_access_token.nil? or kakao_access_token.empty?

      id, nickname = get_me(kakao_access_token)
      user = User.find_by_service_and_identifier(Login::Services::KAKAO, id)
      user = User.create(
        {nickname: nickname, service: Login::Services::KAKAO, identifier: id}
      ) if user.nil?

      access_token = Encryption.encrypt(user.id.to_s)
      cache_key = Login::HardtackAuth.cache_key(access_token)
      Rails.cache.write(cache_key, user.id, expires_in: 3.days)
      access_token
    end
  end
end

