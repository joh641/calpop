class Department < ActiveRecord::Base

  has_many :courses
  has_many :classes, :through => :courses

end
