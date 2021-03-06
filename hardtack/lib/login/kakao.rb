require 'rest-client'
require 'json'

require 'error/bad_request_error'
require 'error/unauthorized_error'

module Login::Kakao
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
      raise Error::UnauthorizedError if e.http_code == 401
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
    get_me(kakao_access_token)
  end
end

