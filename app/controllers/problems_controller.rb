class ProblemsController < ApplicationController
  def show
    @problem = Problem.find_by_id(params['id'])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @problem }
    end
  end

  def index
    @problems = Problem.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @problems }
    end
  end
end
