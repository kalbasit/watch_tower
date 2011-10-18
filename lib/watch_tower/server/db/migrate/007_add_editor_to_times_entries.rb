class AddEditorToTimesEntries < ActiveRecord::Migration
  def change
    add_column :time_entries, :editor, :string, null: false, default: ""
    add_index :time_entries, :editor
  end
end