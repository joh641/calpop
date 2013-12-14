class PopulatesController < ApplicationController
  respond_to :json

  def show
    @departments = Department.all
    @timeslots = Timeslot.all
    if params[:query]
      add(params[:query])
    end
  end  

  private

  def add(query)
    Department.make_department(query, true)
  end

end
