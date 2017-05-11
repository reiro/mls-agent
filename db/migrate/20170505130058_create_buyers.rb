class CreateBuyers < ActiveRecord::Migration[5.0]
  def change
    create_table :buyers do |t|
      t.string :first_name
      t.string :last_name
      t.integer :gender
      t.integer :age, default: 0
      t.float :height
      t.float :weight
      t.integer :marital_status, default: 0
      t.boolean :children_presence, default: false
      t.string :job_status
      t.string :job_field
      t.string :profession
      t.integer :education, default: 0
      t.boolean :pets, default: false
      t.boolean :car_presence
      t.integer :race, default: 0
      t.string :address

      t.timestamps
    end
  end
end
