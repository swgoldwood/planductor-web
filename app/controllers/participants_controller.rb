class ParticipantsController < ApplicationController
  def create
    @participant = Participant.new(params[:participant])
    @competition = Competition.find(params[:participant][:competition_id])

    respond_to do |format|
      if @participant.save
        flash[:success] = 'Planner was successfully added.'
        format.html { redirect_to @competition }
      else
        flash[:warning] = 'There was a problem. Planner was not added'
        format.html { redirect_to @competition }
      end
    end
  end

  def destroy
  end
end
