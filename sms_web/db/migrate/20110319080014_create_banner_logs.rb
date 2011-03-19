class CreateBannerLogs < ActiveRecord::Migration
  def self.up
    create_table :banner_logs do |t|
      t.integer :banner_id
      t.string :action
      t.string :user_agent

      t.timestamps
    end
  end

  def self.down
    drop_table :banner_logs
  end
end
