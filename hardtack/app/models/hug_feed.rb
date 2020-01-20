class HugFeed < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :emotion
  belongs_to :hugger, class_name: 'User'
end

