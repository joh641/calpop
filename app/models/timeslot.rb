class Timeslot < ActiveRecord::Base

  has_and_belongs_to_many :sections

  def self.make_timeslot(day, start_time)
    timeslot = find_timeslot(day, start_time)
    if not timeslot
      timeslot = Timeslot.new
      timeslot.day = day
      timeslot.start_time = start_time
      timeslot.save
    end
    return timeslot
  end

  def self.find_timeslot(day, start_time)
    self.find_by_day_and_start_time(day, start_time)
  end

end
