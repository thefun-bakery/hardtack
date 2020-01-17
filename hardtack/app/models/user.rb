class User < ApplicationRecord
  attribute :nickname
  attribute :profile_image_url
  attribute :service
  attribute :identifier

  has_one :home
end
