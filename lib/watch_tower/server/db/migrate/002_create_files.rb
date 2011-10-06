class CreateFiles < ActiveRecord::Migration
  def change
    create_table :files do |t|
      t.references :project, null: false
      t.string :path, null: false
      t.integer :elapsed_time, default: 0
      t.integer :time_entries_count

      t.timestamps
    end

    add_index :files, :project_id
    add_index :files, :path, unique: true
  end
end