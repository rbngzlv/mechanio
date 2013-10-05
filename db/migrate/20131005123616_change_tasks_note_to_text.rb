class ChangeTasksNoteToText < ActiveRecord::Migration
  def change
    change_column :tasks, :note, :text
  end
end
