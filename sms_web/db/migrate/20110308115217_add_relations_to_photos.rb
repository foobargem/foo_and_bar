class AddRelationsToPhotos < ActiveRecord::Migration
  def self.up
    add_column :photos, :company_id, :integer
    add_column :photos, :car_id, :integer
    add_column :photos, :racing_model_id, :integer
  end

  def self.down
    remove_column :photos, :company_id
    remove_column :photos, :car_id
    remove_column :photos, :racing_model_id
  end
end
