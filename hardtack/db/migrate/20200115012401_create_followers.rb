class CreateFollowers < ActiveRecord::Migration[6.0]
  def change
    create_table :followers do |t|
      t.belongs_to :followee, null: false, class_name: 'User'
      t.belongs_to :follower, null: false, class_name: 'User'
      t.timestamps
    end
    add_index :followers, [:followee_id, :follower_id], unique: true
  end
end
