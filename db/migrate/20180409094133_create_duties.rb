class CreateDuties < ActiveRecord::Migration[5.1]
  def change
    create_table :duties do |t|
      t.time :start_time
      t.time :exit_time
      t.date :duty_date
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
