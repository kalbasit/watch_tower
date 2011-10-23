# -*- encoding: utf-8 -*-

class RemoveEditorIndexFromTimeEntries < ActiveRecord::Migration
  def change
    remove_index :time_entries, :editor
  end
end