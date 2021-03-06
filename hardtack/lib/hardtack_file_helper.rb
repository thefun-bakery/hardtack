require 'fog/aws'
require 'openssl'
require 'base64'

module HardtackFileHelper
  #TIME_TO_ACCESS        = 20.seconds
  EXPIRE_TIME_UPLOAD    = 20.minutes
  EXPIRE_TIME_DOWNLOAD  = 20.minutes
  AWS_ACCESS_KEY_ID     = Rails.application.credentials.aws[:access_key_id]
  AWS_SECRET_ACCESS_KEY = Rails.application.credentials.aws[:secret_access_key]
  REGION                = Rails.application.credentials.aws[:region]
  BUCKET                = Rails.application.credentials.aws[:bucket]
  KEY                   = Rails.application.credentials.hardtack[:auth][:key]
  PATH_PREFIX           = 'hardtack/images'

  DEFAULT_PROFILE_IMAGE_URL = 'https://thefun-bakery-public.s3.ap-northeast-2.amazonaws.com/images/fairy-tales-4057425_640.jpg'


  def self.client
    Fog::Storage.new(
      provider: 'AWS',
      aws_access_key_id: AWS_ACCESS_KEY_ID,
      aws_secret_access_key: AWS_SECRET_ACCESS_KEY,
      region: REGION 
    )
  end

  def self.prepare_upload(user)
    filename = OpenSSL::HMAC.hexdigest("SHA256", KEY, Time.now.to_i.to_s)
    HardtackFile.create(user_id: user.id, name: filename)
    upload_url = self.client.put_object_url(
      BUCKET,
      path(filename),
      EXPIRE_TIME_UPLOAD.from_now.to_i
    )

    return filename, upload_url
  end

  def self.get_download_url(filename)
    self.client.get_object_url(
      BUCKET,
      path(filename),
      EXPIRE_TIME_DOWNLOAD.from_now.to_i
    )
  end

  def self.get_profile_image_url(filename)
    filename.nil? ?
      DEFAULT_PROFILE_IMAGE_URL :
      self.get_download_url(filename)
  end

  def self.path(filename)
    "#{PATH_PREFIX}/#{filename}"
  end
end
