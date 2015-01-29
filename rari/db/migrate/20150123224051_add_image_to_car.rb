class AddImageToCar < ActiveRecord::Migration
  def change
    add_column :cars, :image, :string
  end
end
