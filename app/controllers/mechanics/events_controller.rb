class Mechanics::EventsController < Mechanics::ApplicationController
  def index
    @events = current_mechanic.event_feed
    @from = [9, 11, 13, 15, 17].map { |t| [Time.now.change(hour: t).strftime('%l %p'), t] }
    @to   = [11, 13, 15, 17, 19].map { |t| [Time.now.change(hour: t).strftime('%l %p'), t] }
  end

  def create
    if event = events_manager.create_event(permitted_params)
      redirect_to mechanics_events_path
    else
      flash.now[:error] = event.errors.full_messages
      render :index
    end
  end

  def destroy
    if events_manager.delete_event(params[:id])
      head :ok
    else
      head 406
    end
  end


  private

  def permitted_params
    params.require(:event).permit(:date_start, :time_start, :time_end, :repeat, :recurrence, :ends, :ends_after_count, :ends_on)
  end

  def events_manager
    @events_manager ||= EventsManager.new(current_mechanic)
  end
end
