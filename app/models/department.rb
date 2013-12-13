class Department < ActiveRecord::Base

  include AdditionalMethods

  has_many :courses
  has_many :classinstances, :through => :courses

  @@app_id = ENV['STUDENT_INFORMATION_APP_ID']
  @@app_key = ENV['STUDENT_INFORMATION_APP_KEY']


  def self.make_department(department_name)
    uri = "https://apis-dev.berkeley.edu/cxf/asws/department?departmentName=#{CGI.escape(department_name)}&_type=xml&app_id=#{@@app_id}&app_key=#{@@app_key}"
    begin
      doc = call_api(uri)
      department_name = doc.xpath("//departmentName").text
      department_code = doc.xpath("//departmentCode").text
      department = find_department(department_code)
      if not department
        department = Department.new
        department.name = department_name
        department.department_code = department_code
        department.save
        department.update_courses
      end
      return department
    rescue => e
    end
  end

  def self.find_department(department_code)
    self.find_by_department_code(department_code)
  end

  def update_courses
    uri = "https://apis-dev.berkeley.edu/cxf/asws/course?departmentCode=#{CGI.escape(self.department_code)}&_type=xml&app_id=#{@@app_id}&app_key=#{@@app_key}"
    begin
      doc = Department.call_api(uri)
      courses = doc.xpath("//CanonicalCourse")
      courses.each do |course|
        course_number = course.xpath("courseNumber").text
        course_uid = course.xpath("courseUID").text
        begin
          self.courses << Course.make_course(course_number, course_uid, self.department_code)
        rescue => e
          next
        end
      end
      self.last_updated = DateTime.now
      self.save
    rescue => e
    end
  end

  def get_department_population
    population = 0
    self.classinstances.each do |classinstance|
      population += classinstance.get_class_population
    end
    population
  end

end
