class Measurement < ApplicationRecord
  # model association
  belongs_to :habit, class_name: 'Habit', foreign_key: 'habit_id'
  belongs_to :user, class_name: 'User', foreign_key: 'user_id'

  # validations
  validates_presence_of :value, :date

  scope :today, -> { where('date = ?', Date.today) }
  scope :yesterday, -> { where('date = ?', Date.yesterday) }
  scope :last_week, -> { where('date < ?', Date.yesterday) }
end
