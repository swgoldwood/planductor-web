class PlannersController < ApplicationController

  def index
    @planners = Planner.all

    respond_to do |format|
      format.html
      format.json { render json: @planners }
    end
  end

  def show
    @planner = Planner.find_by_id(params[:id])
  end

  def create
    @planner = Planner.new(params[:planner])

    if @planner.save
      flash[:success] = 'Planner was successfully added'
    else
      flash[:warning] = 'Error adding planner'
    end
    redirect_to(@planner.user)
  end

  def destroy
    @planner = Planner.find(params[:id])
    @planner.destroy

    redirect_to(@planner.user)
  end
end
