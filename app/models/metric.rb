class Metric < ActiveRecord::Base
  belongs_to :application

  validates :application_id, uniqueness: {scope: :bucket} 
end
