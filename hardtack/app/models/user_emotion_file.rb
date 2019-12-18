class UserEmotionFile < ApplicationRecord
  belongs_to :user_emotion
  belongs_to :file, class_name: :HardtackFile
end

