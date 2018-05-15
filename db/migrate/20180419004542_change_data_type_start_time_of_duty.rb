class ChangeDataTypeStartTimeOfDuty < ActiveRecord::Migration[5.1]
  def change
    change_column :duties, :start_time, :string
    change_column :duties, :exit_time, :string
  end
end
