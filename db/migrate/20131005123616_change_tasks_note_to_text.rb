class ChangeTasksNoteToText < ActiveRecord::Migration
  def up
    change_column :tasks, :note, :text
  end

  def down
  end
end
