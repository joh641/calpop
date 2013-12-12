class RemoveEndTimeFromTimeslots < ActiveRecord::Migration
  def change
    remove_column :timeslots, :end_time
  end
end
