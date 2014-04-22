class ExperimentsController < ApplicationController
  def create
    competition = Competition.find_by_id(params[:experiment][:competition_id])

    experiment_number = 0
    if competition.experiments.any?
      competition.experiments.each do |ex|
        experiment_number = ex.experiment_number if experiment_number < ex.experiment_number
      end
    end

    error_msg = ""
    params[:experiment][:problem_id].each do |id|
      if not id.empty?
        experiment_number += 1

        ex_args = params[:experiment]
        ex_args[:problem_id] = id
        ex_args[:experiment_number] = experiment_number

        @experiment = Experiment.new(ex_args)
        
        if not @experiment.save
          error_msg << " Adding problem_id #{id.to_s} failed, args= #{ex_args.to_s} |"
        end
      end
    end

    if error_msg.empty?
      flash[:success] = 'Experiments were successfully added to competition'
    else
      flash[:warning] = error_msg
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
