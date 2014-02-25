class EventApplication < ActiveRecord::Base
  RAW_EVENTS = 'events:raw'
  validates_uniqueness_of :name
end
