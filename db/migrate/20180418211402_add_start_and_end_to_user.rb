class AddStartAndEndToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users,:start, :string
    add_column :users,:end, :string
  end
end
