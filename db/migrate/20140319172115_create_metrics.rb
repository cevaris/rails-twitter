class CreateMetrics < ActiveRecord::Migration
  def change
    create_table :metrics do |t|
      t.integer :application_id
      t.string  :bucket
      t.text    :data

      t.timestamps
    end
  end
end
