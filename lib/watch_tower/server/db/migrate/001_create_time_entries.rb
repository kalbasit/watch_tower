class CreateTimeEntries < ActiveRecord::Migration
  def change
    create_table :time_entries do |t|
      t.string :path, null: false
      t.datetime :mtime, null: false

      t.timestamps
    end

    add_index :time_entries, :path
  end
end