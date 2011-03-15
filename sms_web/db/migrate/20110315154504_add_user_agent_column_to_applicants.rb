class AddUserAgentColumnToApplicants < ActiveRecord::Migration
  def self.up
    add_column :applicants, :user_agent, :string
  end

  def self.down
    remove_column :applicants, :user_agent
  end
end
