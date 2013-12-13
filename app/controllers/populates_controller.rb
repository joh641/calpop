class PopulatesController < ApplicationController

  def show
    @departments = Department.all
    if params[:query]
      add(params[:query])
    end
  end  

  private

  def add(query)
    Department.make_department(query, true)
  end

end
