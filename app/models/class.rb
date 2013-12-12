class Class < ActiveRecord::Base
  
  belongs_to :course
  has_many :sections
  has_many :timeslots, :through => :sections

  @@app_id = ENV['STUDENT+INFORMATION_APP_ID']
  @@app_key = ENV['STUDENT_INFORMATION_APP_KEY']

end
