class EventsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:create]

  def create
    event_handler.dump_events(params[:raw_events])
    render status: 200, nothing: true
  end
end
