class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.integer :department_id
      t.string :name
      t.string :course_uid
      t.datetime :last_updated
    end
  end
end
