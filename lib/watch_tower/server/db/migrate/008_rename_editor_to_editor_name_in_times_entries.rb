class RenameEditorToEditorNameInTimesEntries < ActiveRecord::Migration
  rename_column :time_entries, :editor, :editor_name
end