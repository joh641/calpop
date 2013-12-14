class Department < ActiveRecord::Base

  include AdditionalMethods

  has_many :courses
  has_many :classinstances, :through => :courses

  @@app_id = ENV['STUDENT_INFORMATION_APP_ID']
  @@app_key = ENV['STUDENT_INFORMATION_APP_KEY']

  # takes a department's name and make a call to find the department's code
  def self.make_department(department_name, query= false)
    uri = "https://apis-dev.berkeley.edu/cxf/asws/department?departmentName=#{CGI.escape(department_name)}&_type=xml&app_id=#{@@app_id}&app_key=#{@@app_key}"
    begin
      doc = call_api(uri)
      departments = doc.xpath("//CanonicalDepartment")
      departments.each do |canonical_department|
        department_name = canonical_department.xpath("departmentName").text
        department_code = canonical_department.xpath("departmentCode").text
        department = find_department(department_code, department_name)
        if not department
          department = Department.new
          department.name = department_name
          department.department_code = department_code
          department.save
          department.update_courses
        end
        begin
          department.update_courses if not query
        rescue => e
          puts "error in multiple department creation: " + e.message
          next
        end
      end
    rescue => e
      puts "error in department creation: " + e.message
    end
  end

  def self.find_department(department_code, department_name)
    self.find_by_department_code(department_code) or self.find_by_name(department_name)
  end

  # uses department's code to search for the courses offered by that department, then adds those courses to the department
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
          puts "error in multiple course creation: " + e.message
          next
        end
      end
      self.last_updated = DateTime.now
      self.save
    rescue => e
      puts "error in course creation: " + e.message
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
