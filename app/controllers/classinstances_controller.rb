class ClassinstancesController < ApplicationController

  def show
    @classinstance = Classinstance.find_by_id(params[:id])
  end  

end
