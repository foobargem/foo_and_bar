class AddApplicantsCountColumntToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :applicants_count, :integer
  end

  def self.down
    remove_column :events, :applicants_count
  end
end
