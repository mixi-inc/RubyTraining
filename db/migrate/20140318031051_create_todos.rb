class CreateTodos < ActiveRecord::Migration
  def change
    create_table :todos do |t|
      t.text    :title
      t.integer :order
      t.boolean :done
    end
  end
end
