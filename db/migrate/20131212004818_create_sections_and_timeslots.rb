class CreateSectionsAndTimeslots < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.integer :class_id
      t.integer :timeslot_id
      t.string :building
      t.integer :population
      t.datetime :last_updated
    end

    create_table :timeslots do |t|
      t.string :day
      t.time :start_time
      t.time :end_time
    end

    create_table :sections_timeslots do |t|
      t.belongs_to :section
      t.belongs_to :timeslot
    end
  end
end
