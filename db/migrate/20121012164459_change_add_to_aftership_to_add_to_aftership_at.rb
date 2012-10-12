class ChangeAddToAftershipToAddToAftershipAt < ActiveRecord::Migration
  def up
    rename_column :aftership_trackings, :add_to_aftership, :add_to_aftership_at
  end

  def down
    rename_column :aftership_trackings, :add_to_aftership_at, :add_to_aftership
  end
end
