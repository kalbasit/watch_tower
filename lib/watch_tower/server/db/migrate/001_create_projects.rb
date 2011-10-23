# -*- encoding: utf-8 -*-

class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.string :path, null: false
      t.integer :elapsed_time, default: 0
      t.integer :files_count

      t.timestamps
    end

    add_index :projects, :name
    add_index :projects, :path
  end
end