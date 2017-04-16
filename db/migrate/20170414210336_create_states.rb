class CreateStates < ActiveRecord::Migration[5.0]
  def change
    create_table :states do |t|
      t.string :city
      t.string :state_short
      t.string :state_full
      t.string :alias
      t.string :county
    end
  end
end
