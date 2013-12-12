class Class < ActiveRecord::Base
  
  belongs_to :course
  has_many :sections
  has_many :timeslots, :through => :sections

end
