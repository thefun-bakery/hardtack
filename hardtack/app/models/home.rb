class Home < ApplicationRecord
  belongs_to :user
  has_one :home_visit_count
end
