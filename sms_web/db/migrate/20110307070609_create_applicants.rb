class CreateApplicants < ActiveRecord::Migration
  def self.up
    create_table :applicants do |t|
      t.integer :event_id

      t.string :name
      t.string :address
      t.string :phone_number
      t.string :email

      t.timestamps
    end
  end

  def self.down
    drop_table :applicants
  end
end
