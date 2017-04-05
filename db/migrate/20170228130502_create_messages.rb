class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.text :body
      t.integer :sender_id, index: true
      t.integer :recipient_id, index: true
      t.references :user, index: true
      t.references :agent_room, index: true

      t.timestamps
    end
  end
end
