class CreateHomeVisitHistories < ActiveRecord::Migration[6.0]
  def change
    create_table :home_visit_histories do |t|
      t.belongs_to :home
      t.belongs_to :user
      t.timestamps
    end
  end
end
