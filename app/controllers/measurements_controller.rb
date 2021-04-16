class MeasurementsController < ApplicationController
  before_action :set_habit
  before_action :set_habit_measurement, only: [:show, :update, :destroy]

  # GET /habits/:habit_id/measurements
  def index
    json_response(@habit.measurements)
  end

  # GET /habits/:habit_id/measurements/:id
  def show
    json_response(@measurement)
  end

  # POST /habits/:habit_id/measurements
  def create
    @habit.measurements.create!(measurement_params)
    json_response(@habit, :created)
  end

  # PUT /habits/:habit_id/measurements/:id
  def update
    @measurement.update(measurement_params)
    head :no_content
  end

  # DELETE /habits/:habit_id/measurements/:id
  def destroy
    @measurement.destroy
    head :no_content
  end

  private

  def measurement_params
    params.permit(:value, :date)
  end

  def set_habit
    @habit = Habit.find(params[:habit_id])
  end

  def set_habit_measurement
    @measurement = @habit.measurements.find_by!(id: params[:id]) if @habit
  end
end
