class ParticipantsController < ApplicationController
  def create
    @planner = Planner.find_by_id(params[:participant][:planner_id])

    if current_user.id != @planner.user_id
      unauthorized
    else
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
  end

  def destroy
  end

  private
    def current_resource
      @current_resource ||= Participant.find_by_id(params[:id]) if params[:id]
    end
end
