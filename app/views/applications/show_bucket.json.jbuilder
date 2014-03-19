json.metric do 
  json.extract! @metric, :bucket, :data, :created_at, :updated_at
end

json.application do 
  json.extract! @application, :id, :name, :created_at, :updated_at
end
