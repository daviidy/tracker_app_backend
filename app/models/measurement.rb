class Measurement < ApplicationRecord
    # model association
  belongs_to :habit, class_name: "Habit", foreign_key: "habit_id"

  # validations
  validates_presence_of :value, :date
end
