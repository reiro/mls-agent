class CreateAgents < ActiveRecord::Migration[5.0]
  def change
    create_table :agents do |t|
      t.string :name
      t.belongs_to :agent_room, index: true
      t.boolean :has_greetings, default: false
      t.boolean :has_actions, default: false
      t.boolean :has_beds, default: false
      t.boolean :has_baths, default: false
      t.boolean :has_min_price, default: false
      t.boolean :has_max_price, default: false
      t.boolean :has_address, default: false
      t.boolean :has_general, default: false
      t.string :greetings
      t.string :actions
      t.string :beds
      t.string :baths
      t.integer :min_price
      t.integer :max_price
      t.jsonb :address, default: {}, null: false
      t.jsonb :data, default: {}, null: false
    end
  end
end
