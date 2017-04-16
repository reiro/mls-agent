class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.text :body
      t.references :user, index: true
      t.references :agent_room, index: true
      t.references :agent, index: true
      t.integer :sender_type, default: 0

      t.timestamps
    end
  end
end
