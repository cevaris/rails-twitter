class Application < ActiveRecord::Base
  RAW_EVENTS = 'events:raw'
  validates_uniqueness_of :name

  belongs_to :user
  has_many :metrics
end
