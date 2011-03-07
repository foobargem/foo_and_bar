class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :name

      t.string :status

      t.timestamp :opened_at
      t.timestamp :closed_at

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
