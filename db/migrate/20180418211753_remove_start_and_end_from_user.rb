class RemoveStartAndEndFromUser < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :start
    remove_column :users, :end
  end
end
