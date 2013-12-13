class Department < ActiveRecord::Base

  include AdditionalMethods

  has_many :courses
  has_many :classinstances, :through => :courses

  @@app_id = ENV['STUDENT_INFORMATION_APP_ID']
  @@app_key = ENV['STUDENT_INFORMATION_APP_KEY']

  def self.make_department(department_name)
    uri = "https://apis-dev.berkeley.edu/cxf/asws/department?departmentName=#{CGI.escape(department_name)}&_type=xml&app_id=#{@@app_id}&app_key=#{@@app_key}"
    doc = call_api(uri)
    begin
      department_name = doc.xpath("//departmentName").text
      department_code = doc.xpath("//departmentCode").text
      department = Department.new
      department.name = department_name
      department.department_code = department_code
      department.save
      department.update_courses
      return department
    rescue => e
    end
  end

  def update_courses
    sleep(10)
    uri = "https://apis-dev.berkeley.edu/cxf/asws/course?departmentCode=#{self.department_code}&_type=xml&app_id=#{@@app_id}&app_key=#{@@app_key}"
    doc = call_api(uri)
    begin
      courses = doc.xpath("//CanonicalCourse")
      courses.each do |course|
        course_number = course.xpath("courseNumber").text
        course_uid = course.xpath("courseUID").text
        self.courses << Course.make_course(course_number, course_uid)
      end
      self.last_updated = DateTime.now
      self.save
    rescue => e
    end
  end

end
