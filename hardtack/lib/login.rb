require 'encryption'
require 'login/hardtack_auth'
require 'login/services'
require 'login/kakao'

require 'error/internal_server_error'

module Login
  include Kakao

  def self.login_by_kakao(kakao_access_token)
    identifier, nickname = Login::Kakao.login(kakao_access_token)
    user = self.regist(Login::Services::KAKAO, identifier, nickname)
    self.login(user)
  end

  def self.regist(service, identifier, nickname)
      user = User.find_by_service_and_identifier(service, identifier)
      
      if user.nil?
        begin
          ActiveRecord::Base.transaction do
            user = User.create(
              {nickname: nickname, service: service, identifier: identifier}
            )

            Home.create(user_id: user.id)
          end
        rescue => e
          raise ActiveRecord::Rollback
        end
      end

      user
  end

  def self.login(user)
      access_token = Encryption.encrypt(user.id.to_s)
      cache_key = Login::HardtackAuth.cache_key(access_token)
      Rails.cache.write(cache_key, user.id, expires_in: 3.days)
      access_token
  end
end
