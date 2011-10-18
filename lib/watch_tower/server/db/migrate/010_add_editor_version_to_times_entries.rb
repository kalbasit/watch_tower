class AddEditorVersionToTimesEntries < ActiveRecord::Migration
  def change
    add_column :time_entries, :editor_version, :string, null: false, default: ""
  end
end