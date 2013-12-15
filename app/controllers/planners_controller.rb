class PlannersController < ApplicationController

  def index
    @planners = Planner.all

    respond_to do |format|
      format.html
      format.json { render json: @planners }
    end
  end

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
