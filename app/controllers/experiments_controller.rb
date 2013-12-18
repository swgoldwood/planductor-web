class ExperimentsController < ApplicationController
  def create
    @experiment = Experiment.new(params[:experiment])

    if @experiment.save
      flash[:success] = 'Experiment was successfully added to competition'
    else
      flash[:warning] = 'Error adding experiment to competition'
    end
    redirect_to @experiment.competition
  end

  def destroy
    @experiment = Experiment.find(params[:id])
    competition = @experiment.competition
    @experiment.destroy

    respond_to do |format|
      format.html { redirect_to competition }
      format.json { head :no_content }
    end
  end
end
