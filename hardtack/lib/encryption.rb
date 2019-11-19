module Encryption
  KEY = Rails.application.credentials.hardtack[:auth][:key]

  def self.encrypt(value)
    AES.encrypt(value, KEY)
  end

  def self.decrypt(value)
    AES.decrypt(value, KEY)
  end
end
