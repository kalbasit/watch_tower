# -*- encoding: utf-8 -*-

class CreateDurations < ActiveRecord::Migration
  def change
    create_table :durations do |t|
      t.references :file, null: false
      t.date :date, null: false
      t.integer :duration, default: 0

      t.timestamps
    end

    add_index :durations, :file_id
    add_index :durations, :date
  end
end