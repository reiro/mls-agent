class UpdateListings < ActiveRecord::Migration[5.0]
  def change
    add_column :listings, :schools_count, :integer, default: 0
    add_column :listings, :top_school_rating, :integer
    add_column :listings, :top_school_name, :string
    add_column :listings, :top_school_distance, :float
  end
end
