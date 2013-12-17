class PopulatesController < ApplicationController
  respond_to :json

  def show
    @timeslots = Timeslot.find_all
    @timeslots = @timeslots.day_equals(params[:day]) if params[:day]
    @timeslots = @timeslots.start_time_equals(Time.strptime(params[:start_time].to_s, "%H%M")) if params[:start_time]
    render :partial => "populates/show.json"
  end  

  private

  def add(query)
    Department.make_department(query, true)
  end

end
