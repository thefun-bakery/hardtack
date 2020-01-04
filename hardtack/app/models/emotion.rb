class Emotion < ApplicationRecord
  belongs_to :user
  belongs_to :home
  has_many :emotion_files
  has_many :files, through: :emotion_files
  has_one :emotion_hug_count
end
