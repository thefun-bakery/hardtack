class CreateHomes < ActiveRecord::Migration[6.0]
  def change
    create_table :homes do |t|
      t.belongs_to :users
      t.string :name, :null => false, :default => 'my home'
      t.integer :bgcolor, :null => false, :default => 0
      t.timestamps
    end
  end
end
