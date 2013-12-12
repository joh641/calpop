class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.string :name
      t.string :department_code
      t.datetime :last_updated
    end
  end
end
