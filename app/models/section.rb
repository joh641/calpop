class Section < ActiveRecord::Base

  include AdditionalMethods

  belongs_to :classinstance
  has_and_belongs_to_many :timeslots

  # makes section from the given input, then updates the timeslots occupied by the section
  def self.make_section(building, population, days, start_time, end_time, classinstance)
    section = find_section(building, classinstance)
    if not section
      section = Section.new
      section.building = building
      section.population = population
      section.save
    else
      section.update_population(population)
    end
    begin
      section.update_timeslots(days, start_time, end_time)
    rescue => e
      puts "error in timeslot creation: " + e.message
    end
    return section
  end

  def self.find_section(building, classinstance)
    self.find_all_by_building(building).each do |section|
      if section.classinstance == classinstance 
        return section
      end
    end
    return false
  end

  def update_population(population)
    self.population = population
    self.save
  end

  def get_section_population
    self.population + 1
  end

  # determines which timeslots the section occupies from the given day, start time, and end time, then adds them to that section
  def update_timeslots(days, start_time, end_time)
    times = Section.split_times(start_time, end_time)
    day_abbs = ["S", "M", "T", "W", "T", "F", "S"]
    day_full = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    i = 0
    days.split("").each do |char|
      if char == day_abbs[i]
        times.each do |time|
          self.timeslots << Timeslot.make_timeslot(day_full[i], time) if not contains_timeslot?(day_full[i], time)
        end
      end
      i += 1
    end
    self.last_updated = DateTime.now
    self.save
  end    

  def contains_timeslot?(day, time)
    time = time % 1200
    if time == 0 or time == 30
      time += 1200
    end
    self.timeslots.each do |timeslot|
      if timeslot.day == day and timeslot.start_time.strftime("%I%M").to_i == time
        return true
      end
    end
    return false
  end
    
end
