class ClassinstancesController < ApplicationController

  def show
    @classinstance = Classinstance.find_by_id(params[:id])
  end  

  def update
    classinstance = Classinstance.find_by_id(params[:id])
    classinstance.update_sections
    redirect_to classinstance_path(classinstance)
  end

end
