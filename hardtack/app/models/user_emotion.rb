class UserEmotion < ApplicationRecord
  belongs_to :user
  belongs_to :home
  has_many :user_emotion_files
  has_many :files, through: :user_emotion_files
end
