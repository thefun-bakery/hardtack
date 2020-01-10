class Emotion < ApplicationRecord
  belongs_to :user
  belongs_to :home
  has_many :emotion_files
  has_many :files, through: :emotion_files
  has_one :emotion_hug_count

  def hug_count
    emotion_hug_count.nil? ? 0 : emotion_hug_count.hug_count
  end

  def did_i_hug?(user)
    return false if user.nil? or emotion_hug_count.nil?
    EmotionHugHistory.find_by_emotion_id_and_user_id(id, user.id).nil? ? false : true
  end
end
