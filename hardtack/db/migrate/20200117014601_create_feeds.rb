class CreateFeeds < ActiveRecord::Migration[6.0]
  def change
    create_table :feeds do |t|
      t.belongs_to :follower, null: false, class_name: 'User'
      t.belongs_to :emotion, null: false
      t.timestamps
    end
    add_index :feeds, [:follower_id, :emotion_id], unique: true
  end
end
