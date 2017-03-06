class CreateAgentRooms < ActiveRecord::Migration[5.0]
  def change
    create_table :agent_rooms do |t|
      t.string :title
      t.references :user, foreign_key: true, index: true

      t.timestamps
    end
  end
end
