class PopulatesController < ApplicationController

  def show
    if params[:query]
      add(params[:query])
    end
  end  

  private

  def add(query)
    Department.make_department(query)
  end

end
