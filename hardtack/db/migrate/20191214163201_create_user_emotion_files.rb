class CreateUserEmotionFiles < ActiveRecord::Migration[6.0]
  def change
    create_table :user_emotion_files do |t|
      t.belongs_to :user_emotion
      t.belongs_to :file
      t.timestamps
    end
  end
end
