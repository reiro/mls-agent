class CreateListings < ActiveRecord::Migration[5.0]
  def change
    create_table :listings do |t|
      t.integer :sysid
      t.integer :listing_id
      t.string :property_type
      t.string :property_tax
      t.integer :price
      t.integer :original_list_price
      t.integer :living_area
      t.integer :beds
      t.integer :baths
      t.boolean :garage, default: false
      t.text :description
      t.string :state
      t.string :city
      t.string :street
      t.string :full_street
      t.string :photo

      t.timestamps
    end
  end
end
