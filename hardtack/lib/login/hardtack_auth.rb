module HardtackAuth
  KEY = Rails.application.credentials.hardtack[:auth][:key]

  def self.encrypt(value)
    AES.encrypt(value, KEY)
  end

  def self.is_login?(hardtack_access_token)
    Rails.cache.exist? "session:#{hardtack_access_token}"
  end

  def self.logout?(hardtack_access_token)
    Rails.cache.delete("session:#{hardtack_access_token}") == 1 ? true : false
  end
end
