# -*- encoding: utf-8 -*-

class AddHashToTimeEntries < ActiveRecord::Migration
  def change
    add_column :time_entries, :file_hash, :string, null: false, default: ""
    add_index :time_entries, :file_hash
  end
end