class CreateEmotionHugHistories < ActiveRecord::Migration[6.0]
  def change
    create_table :emotion_hug_histories do |t|
      t.belongs_to :emotion
      t.belongs_to :user
      t.timestamps
    end

    add_index :emotion_hug_histories, [:emotion_id, :user_id], unique: true
  end
end
