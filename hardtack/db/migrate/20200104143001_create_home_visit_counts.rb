class CreateHomeVisitCounts < ActiveRecord::Migration[6.0]
  def change
    create_table :home_visit_counts do |t|
      t.belongs_to :home
      t.integer :visit_count, default: 1
      t.timestamps
    end
  end
end
