class AddDescColumnToCars < ActiveRecord::Migration
  def self.up
    add_column :cars, :desc, :text
  end

  def self.down
    remove_column :cars, :desc
  end
end
