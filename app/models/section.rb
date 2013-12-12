class Section < ActiveRecord::Base

  belongs_to :class
  has_and_belongs_to_many :timeslots

end
