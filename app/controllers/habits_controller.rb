class HabitsController < ApplicationController
  before_action :set_habit, only: %i[show update destroy]

  # GET /habits
  def index
    @habits = Habit.all
    json_response(@habits)
  end

  # POST /habits
  def create
    @habit = Habit.create!(habit_params)
    json_response(@habit, :created)
  end

  # GET /habits/:id
  def show
    json_response(@habit)
  end

  # PUT /habits/:id
  def update
    @habit.update(habit_params)
    head :no_content
  end

  # DELETE /habits/:id
  def destroy
    @habit.destroy
    head :no_content
  end

  private

  def habit_params
    # whitelist params
    params.permit(:name)
  end

  def set_habit
    @habit = Habit.find(params[:id])
  end
end
