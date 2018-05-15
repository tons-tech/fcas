class AddAndDeleteColumns < ActiveRecord::Migration[5.1]
  def up
    add_column :Users, :name, :string
  end

  def down
    remove_column :Users, :first_name, :string
    remove_column :Users, :last_name, :string
  end
end
