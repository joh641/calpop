class DepartmentsController < ApplicationController

  def show
    @department = Department.find_by_id(params[:id])
  end  

  def update
    department = Department.find_by_id(params[:id])
    department.update_courses
    redirect_to department_path(department)
  end

end
