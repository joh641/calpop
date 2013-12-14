class TimeslotsController < ApplicationController

  def show
    @timeslot = Timeslot.find_by_id(params[:id])
  end  

end
