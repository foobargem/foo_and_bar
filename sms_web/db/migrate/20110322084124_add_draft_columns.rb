class AddDraftColumns < ActiveRecord::Migration
  def self.up
    add_column :companies, :priority, :integer, :default => 100
    add_column :companies, :published, :boolean, :default => true

    add_column :cars, :published, :boolean, :default => true

    add_column :racing_models, :published, :boolean, :default => true

    add_column :photos, :published, :boolean, :default => true
  end

  def self.down
    remove_column :companies, :priority
    remove_column :companies, :published

    remove_column :cars, :published

    remove_column :racing_models, :published

    remove_column :photos, :published
  end
end
