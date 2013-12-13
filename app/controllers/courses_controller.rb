class CoursesController < ApplicationController

  def update
    course = Course.find_by_id(params[:id])
    course.update_classes(course.department.department_code)
    redirect_to department_path(course.department)
  end

end
