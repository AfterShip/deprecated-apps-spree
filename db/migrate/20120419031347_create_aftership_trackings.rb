class CreateAftershipTrackings < ActiveRecord::Migration
  def change
    create_table :aftership_trackings do |t|
      t.string :tracking
      t.string :email
      t.string :order_number
      t.datetime :add_to_aftership

      t.timestamps
    end
  end
end
