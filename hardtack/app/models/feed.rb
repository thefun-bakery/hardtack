class Feed < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :emotion
end

