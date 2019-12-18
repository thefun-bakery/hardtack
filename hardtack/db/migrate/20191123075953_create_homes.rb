class CreateHomes < ActiveRecord::Migration[6.0]
  def change
    create_table :homes do |t|
      t.belongs_to :user
      t.string :name, :null => false, :default => 'my home'
      t.string :desc, :null => false, :default => 'welcome'
      t.string :bgcolor, :null => false, :default => '000000'
      t.timestamps
    end
  end
end
