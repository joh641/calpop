class ClassInstance < ActiveRecord::Base
  
  include AdditionalMethods

  belongs_to :course
  has_many :sections
  has_many :timeslots, :through => :sections

  @@app_id = ENV['STUDENT_INFORMATION_APP_ID']
  @@app_key = ENV['STUDENT_INFORMATION_APP_KEY']

  def self.make_class(name, class_uid, semester, year)
    this_class = ClassInstance.new
    this_class.name = name
    this_class.class_uid = class_uid
    this_class.semester = semester
    this_class.year = year
    this_class.save
    this_class.update_sections
    return this_class
  end

  def update_sections
    uri = "https://apis-dev.berkeley.edu/cxf/asws/classoffering/#{CGI.escape(self.class_uid)}?_type=xml&app_id=#{@@app_id}&app_key=#{@@app_key}"
    doc = call_api(uri)
    begin
      sections = doc.xpath("//sections").xpath("//sectionMeetings")
      holder = doc.xpath("//sections")
      i = 0
      sections.each do |section|
        building = section.xpath("building").text
        population = holder.xpath("studentsEnrolled").text.to_i + holder[i].xpath("waitlistSize").text.to_i
        days = section.xpath("meetingDay").text
        start_time = section.xpath("startTime").text
        end_time = section.xpath("endTime").text
        self.sections << Section.make_section(building, population, days, start_time, end_time)
        i += 1
      end
      self.last_updated = DateTime.now
      self.save
    rescue => e
    end
  end

end
