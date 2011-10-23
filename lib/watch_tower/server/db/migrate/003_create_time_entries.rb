# -*- encoding: utf-8 -*-

class CreateTimeEntries < ActiveRecord::Migration
  def change
    create_table :time_entries do |t|
      t.references :file, null: false
      t.datetime :mtime, null: false

      t.timestamps
    end

    add_index :time_entries, :file_id
  end
end