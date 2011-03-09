class AddIndexes < ActiveRecord::Migration
  def self.up
    add_index :companies, :name

    add_index :cars, :name

    add_index :racing_models, :name

    add_index :videos, :title

    add_index :applicants, :name
    add_index :applicants, :phone_number
  end

  def self.down
    remove_index :companies, :name

    remove_index :cars, :name

    remove_index :racing_models, :name

    remove_index :videos, :title

    remove_index :applicants, :name
    remove_index :applicants, :phone_number
  end
end
