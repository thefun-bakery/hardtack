class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :nickname, :null => false
      t.string :service, :limit => 10, :null => false
      t.string :identifier, :null => false
      t.string :profile_image_filename

      t.timestamps
    end

    add_index :users, [:service, :identifier], unique: true
  end
end
