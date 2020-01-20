class CreateHugFeeds < ActiveRecord::Migration[6.0]
  def change
    create_table :hug_feeds do |t|
      t.belongs_to :follower, null: false, class_name: 'User'
      t.belongs_to :emotion, null: false
      t.belongs_to :hugger, null: false, class_name: 'User'
      t.timestamps
    end
    add_index :hug_feeds, [:follower_id, :emotion_id, :hugger_id], unique: true
  end
end
