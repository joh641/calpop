class RenameNameColumnToCourseNumber < ActiveRecord::Migration
  def change
    rename_column :courses, :name, :course_number
  end
end
