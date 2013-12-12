class Course < ActiveRecord::Base

  include APICaller
  include FindSemester

  belongs_to :department
  has_many :classes

  @@app_id = ENV['STUDENT_INFORMATION_APP_ID']
  @@app_key = ENV['STUDENT_INFORMATION_APP_KEY']

  def self.make_course(course_number, course_uid)
    course = Course.new
    course.course_number = course_number
    course.course_uid = course_uid
    course.save
    course.update_classes
  end

  def update_classes
    semester = find_semester(Date.today)
    year = Date.today.year
    uri = "https://apis-dev.berkeley.edu/cxf/asws/classoffering?courseNumber=#{self.course_number}&departmentCode=#{self.department.department_code}&term=#{semester}&termYear=#{year}&_type=xml&app_id=#{@@app_id}&app_key=#{@@app_key}"
    doc = call_api(uri)
    begin
      classes = doc.xpath("//ClassOffering")
      classes.each do |class_offering|
        name = class_offering.xpath("/courseTitle").text
        class_uid = class_offering.xpath("/classUID").text
        Class.make_class(name, class_uid, semester, year)
      end
      self.last_updated = DateTime.now
      self.save
    rescue => e
    end
  end

end
