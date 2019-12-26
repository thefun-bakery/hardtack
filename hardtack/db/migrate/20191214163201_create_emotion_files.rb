class CreateEmotionFiles < ActiveRecord::Migration[6.0]
  def change
    create_table :emotion_files do |t|
      t.belongs_to :emotion
      t.belongs_to :file
      t.timestamps
    end
  end
end
