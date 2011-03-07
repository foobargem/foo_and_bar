class CreateRacingModels < ActiveRecord::Migration
  def self.up
    create_table :racing_models do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :racing_models
  end
end
