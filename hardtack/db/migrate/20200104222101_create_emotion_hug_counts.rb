class CreateEmotionHugCounts < ActiveRecord::Migration[6.0]
  def change
    create_table :emotion_hug_counts do |t|
      t.belongs_to :emotion
      t.integer :hug_count, default: 1
      t.timestamps
    end
  end
end
