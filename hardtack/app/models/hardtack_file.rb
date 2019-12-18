class HardtackFile < ApplicationRecord
  self.table_name = "files"
  belongs_to :user
end
