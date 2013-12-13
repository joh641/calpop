class Section < ActiveRecord::Base

  include AdditionalMethods

  belongs_to :classinstance
  has_and_belongs_to_many :timeslots

  def self.make_section(building, population, days, start_time, end_time)
    section = find_section(building, population)
    if not section
      section = Section.new
      section.building = building
      section.population = population
      section.save
      section.update_timeslots(days, start_time, end_time)
    else
      section.update_population(population)
    end
    return section
  end

  def self.find_section(building, population)
    self.find_by_building_and_population(building, population)
  end

  def update_population(population)
    self.population = population
  end

  def get_section_population
    self.population
  end

  def update_timeslots(days, start_time, end_time)
    times = Section.split_times(start_time, end_time)
    day_abbs = ["S", "M", "T", "W", "T", "F", "S"]
    day_full = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    i = 0
    days.split("").each do |char|
      if char == day_abbs[i]
        times.each do |time|
          self.timeslots << Timeslot.make_timeslot(day_full[i], time)
        end
      end
      i += 1
    end
    self.last_updated = DateTime.now
    self.save
  end    
    
end
