class CreateEventApplications < ActiveRecord::Migration
  def change
    create_table :event_applications do |t|
      t.string :name

      t.timestamps
    end
  end
end
