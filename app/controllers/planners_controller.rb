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

  def edit
    @planner = Planner.find_by_id(params[:id])
  end

  def new
    @planner = current_user.planners.new
  end

  def create
    @planner = Planner.new(params[:planner])

    respond_to do |format|
      if @planner.save
        Resque.enqueue(ValidatePlanner, @planner.id)
        notice = 'Planner added, pending verification'
        format.html { redirect_to @planner, notice: notice }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @planner = Planner.find(params[:id])

    respond_to do |format|
      if @planner.update_attributes(params[:planner])
        Resque.enqueue(ValidatePlanner, @planner.id)
        format.html { redirect_to @planner, notice: 'Planner was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @planner = Planner.find(params[:id])
    @planner.destroy

    redirect_to(@planner.user)
  end

  private
    def current_resource
      @current_resource ||= Planner.find_by_id(params[:id]) if params[:id]
    end
end
