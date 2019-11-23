class AddProfileImageUrlToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :profile_image_url, :string, :null => false, default: 'https://thefun-bakery.s3.ap-northeast-2.amazonaws.com/hardtack/images/fairy-tales-4057425_640.jpg'
  end
end
