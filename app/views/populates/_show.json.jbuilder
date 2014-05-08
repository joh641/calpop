json.array! @timeslots do |timeslot|
  json.day timeslot.day
  json.time timeslot.start_time.strftime("%I:%M%p")
  json.totalPopulation timeslot.get_timeslot_population
  json.buildings json.array! timeslot.find_buildings do |building|
    building building
    population timeslot.find_building_population(building)
  end
end