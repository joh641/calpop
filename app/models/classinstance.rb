class Classinstance < ActiveRecord::Base
  
  include AdditionalMethods

  belongs_to :course
  has_many :sections
  has_many :timeslots, :through => :sections

  @@app_id = ENV['STUDENT_INFORMATION_APP_ID']
  @@app_key = ENV['STUDENT_INFORMATION_APP_KEY']

  def self.make_class(name, class_uid, semester, year)
    this_class = find_class(class_uid)
    if not this_class
      this_class = Classinstance.new
      this_class.name = name
      this_class.class_uid = class_uid
      this_class.semester = semester
      this_class.year = year
      this_class.save
    end
    this_class.update_sections
    return this_class
  end

  def self.find_class(class_uid)
    self.find_by_class_uid(class_uid)
  end

  def update_sections
    uri = "https://apis-dev.berkeley.edu/cxf/asws/classoffering/#{self.class_uid.gsub(" ", "%20")}?_type=xml&app_id=#{@@app_id}&app_key=#{@@app_key}"
    begin
      doc = Classinstance.call_api(uri)
      sections = doc.xpath("//sections").xpath("//sectionMeetings")
      holder = doc.xpath("//sections")
      i = 0
      sections.each do |section|
        building = section.xpath("building").text
        population = holder[i].xpath("studentsEnrolled").text.to_i + holder[i].xpath("waitlistSize").text.to_i
        days = section.xpath("meetingDay").text
        start_time = section.xpath("startTime").text
        end_time = section.xpath("endTime").text
        i += 1
        self.sections << Section.make_section(building, population, days, start_time, end_time)
      end
      self.last_updated = DateTime.now
      self.save
    rescue => e
    end
  end

  def get_class_population
    population = 0
    self.sections.each do |section|
      population += section.get_section_population
    end
    population
  end

end
