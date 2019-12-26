class EmotionFile < ApplicationRecord
  belongs_to :emotion
  belongs_to :file, class_name: :HardtackFile
end

