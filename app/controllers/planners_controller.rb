class PlannersController < ApplicationController
  def create
    @planner = Planner.new(params[:planner])

    if @planner.save
      flash[:notice] = 'Planner was successfully added'
      redirect_to(@planner.user)
    else
      flash[:notice] = 'Error adding planner'
      redirect_to(@planner.user)
    end
  end

  def destroy
    @planner = Planner.find(params[:id])
    @planner.destroy

    redirect_to(@planner.user)
  end
end
