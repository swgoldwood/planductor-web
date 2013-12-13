class ParticipantsController < ApplicationController
  def create
    @participant = Participant.new(params[:participant])
    @competition = Competition.find(params[:participant][:competition_id])

    respond_to do |format|
      if @participant.save
        format.html { redirect_to @competition, notice: 'Planner was successfully added.' }
      else
        format.html { redirect_to @competition, error: 'Planner was not added' }
      end
    end
  end

  def destroy
  end
end
