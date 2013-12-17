class PopulatesController < ApplicationController
  respond_to :json

  swagger_controller :populates, "Population Query Management"

  swagger_api :show do
    summary "Fetches campus population"
    param :path, :id, :integer, :required, "Populate"
    response :unathorized
    response :not_acceptable
  end

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
