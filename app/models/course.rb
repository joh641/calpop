class Course < ActiveRecord::Base

  belongs_to :department
  has_many :classes

end
