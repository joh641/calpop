class Course < ActiveRecord::Base

  include AdditionalMethods

  belongs_to :department
  has_many :classinstances

  @@app_id = ENV['STUDENT_INFORMATION_APP_ID']
  @@app_key = ENV['STUDENT_INFORMATION_APP_KEY']

  # makes course from given inputs, then updates the class offerings for that course for the current semester 
  def self.make_course(course_number, course_uid, department_code)
    course = find_course(course_uid)
    if not course
      course = Course.new
      course.course_number = course_number
      course.course_uid = course_uid
      course.save
    end
    course.update_classes(department_code)
    return course
  end

  def self.find_course(course_uid)
    self.find_by_course_uid(course_uid)
  end

  # uses the course uid and the current semester to find the class offerings for that course and add it to that course
  def update_classes(department_code)
    semester = Course.find_semester(Date.today)
    year = Date.today.year
    uri = "https://apis-dev.berkeley.edu/cxf/asws/classoffering?courseNumber=#{self.course_number}&departmentCode=#{CGI.escape(department_code)}&term=#{semester}&termYear=#{year}&_type=xml&app_id=#{@@app_id}&app_key=#{@@app_key}"
    begin
      doc = Course.call_api(uri)
      classes = doc.xpath("//ClassOffering")
      classes.each do |class_offering|
        name = class_offering.xpath("courseTitle").text
        class_uid = class_offering.xpath("classUID").text
        begin
          self.classinstances << Classinstance.make_class(name, class_uid, semester, year)
        rescue => e
          puts "error in multiple class creation: " + e.message
          next
        end
      end
      self.last_updated = DateTime.now
      self.save
    rescue => e
      puts "error in class creation: " + e.message
    end
  end

end
