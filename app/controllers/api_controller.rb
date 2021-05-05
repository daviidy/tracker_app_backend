class ApiController < ApplicationController
  before_action :set_default_format
  before_action :authenticate_user!

  def measurement?(user, habit)
    #user.measurements.where('habit_id = ?', habit.id)
    @yesterday = Measurement.yesterday.where('user_id = ?', user.id).order('date DESC')
    @last_week = Measurement.last_week.where('user_id = ?', user.id).order('date DESC')
    [@today, @yesterday, @last_week]
  end
  helper_method :measurement?

  private

  def set_default_format
    request.format = :json
  end
end
