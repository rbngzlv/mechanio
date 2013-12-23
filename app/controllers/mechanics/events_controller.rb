class Mechanics::EventsController < Mechanics::ApplicationController
  def index
  end

  def create
    if events_manager.add_events(params[:event])
      redirect_to mechanics_events_path
    else
      flash.now[:error] = events_manager.errors_full_message
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

  def events
    events_manager.events_list
  end
  helper_method :events

  private

  def events_manager
    @events_manager ||= EventsManager.new(current_mechanic)
  end
end
