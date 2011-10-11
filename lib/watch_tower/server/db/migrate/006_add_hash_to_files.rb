class AddHashToFiles < ActiveRecord::Migration
  def change
    add_column :files, :file_hash, :string, null: false, default: ""
    add_index :files, :file_hash
  end
end