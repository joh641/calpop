class Timeslot < ActiveRecord::Base

  has_and_belongs_to_many :sections

  def self.make_timeslot(day, start_time)
    timeslot = Timeslot.new
    timeslot.day = day
    timeslot.start_time = start_time
    timeslot.save
  end

end
