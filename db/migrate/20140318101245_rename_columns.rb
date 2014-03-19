class RenameColumns < ActiveRecord::Migration
  def change
    rename_column :todos, :title, :task_title
    rename_column :todos, :done, :is_done
  end
end
