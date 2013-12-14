class Timeslot < ActiveRecord::Base

  has_and_belongs_to_many :sections

  # makes a timeslot from the given input
  def self.make_timeslot(day, start_time)
    timeslot = find_timeslot(day, start_time)
    if not timeslot
      timeslot = Timeslot.new
      timeslot.day = day
      timeslot.start_time = Time.strptime(start_time.to_s, "%H%M")
      timeslot.save
    end
    return timeslot
  end

  def self.find_timeslot(day, start_time)
    self.find_by_day_and_start_time(day, Time.strptime(start_time.to_s, "%H%M"))
  end

end
