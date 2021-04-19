class CreateMeasurements < ActiveRecord::Migration[6.0]
  def change
    create_table :measurements do |t|
      t.float :value
      t.date :date
      t.integer :habit_id

      t.timestamps
    end
  end
end
