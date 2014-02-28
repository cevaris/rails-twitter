require 'securerandom'
class AddUuidToEventApplication < ActiveRecord::Migration
  def change
    add_column :event_applications, :uuid, :string
    EventApplication.all.each do |app|
      app.uuid = SecureRandom.uuid
      app.save
    end
  end
end
