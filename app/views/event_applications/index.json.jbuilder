json.array!(@event_applications) do |event_application|
  json.extract! event_application, :id, :name
  json.url event_application_url(event_application, format: :json)
end
