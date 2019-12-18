class CreateHardtackFiles < ActiveRecord::Migration[6.0]
  def change
    create_table :files do |t|
      t.belongs_to :user
      t.string :name, :null => false
      t.boolean :upload_complete, :default => false
      t.timestamps
    end

    add_index :files, [:name], unique: true
  end
end
