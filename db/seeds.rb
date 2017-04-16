# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

states = Rails.root.join('lib', 'data', 'us_cities_states_counties.csv')
CSV.foreach(states, col_sep: '|', headers: :first_row) do |row|
  State.find_or_create_by(city: row['City']) do |s|
    s.state_short = row['State short']
    s.state_full = row['State full']
    s.county = row['County']
    s.alias = row['City alias']
  end
end
