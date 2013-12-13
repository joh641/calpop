class CreateClassInstances < ActiveRecord::Migration
  def change
    create_table :classinstances do |t|
      t.integer :course_id
      t.string :name
      t.string :class_uid
      t.string :semester
      t.integer :year
      t.datetime :last_updated
    end
  end
end
