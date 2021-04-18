class Habit < ApplicationRecord
  # model association
  has_many :measurements, dependent: :destroy

  # validations
  validates_presence_of :name
end
