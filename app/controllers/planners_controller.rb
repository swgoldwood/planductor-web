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

    user = @planner.user

    if @planner.save
      flash[:success] = 'Planner was successfully added'
      Resque.enqueue(ValidateTarball, @planner.id)
    else
      if @planner.errors.any?
        flash[:warning] = @planner.errors.first
      else
        flash[:warning] = 'Error adding planner'
      end
      @planner.destroy
    end

    redirect_to(user)
  end

  def destroy
    @planner = Planner.find(params[:id])
    @planner.destroy

    redirect_to(@planner.user)
  end
end
