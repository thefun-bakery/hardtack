class CreateUserEmotions < ActiveRecord::Migration[6.0]
  def change
    create_table :user_emotions do |t|
      t.belongs_to :user
      t.belongs_to :home
      t.string :emotion_key, :null => false
      t.string :tag
      t.timestamps
    end

    add_index :user_emotions, [:emotion_key]
  end
end
