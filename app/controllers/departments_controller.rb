class DepartmentsController < ApplicationController

  def show
    @department = Department.find_by_id(params[:id])
  end  

end
