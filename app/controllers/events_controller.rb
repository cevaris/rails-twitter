class EventsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:create]

  def create
    event_handler.write(params[:events])
    render status: 200, nothing: true
  end
end
