namespace :populate do
  desc "Generate Static Pages"
  task buyers: :environment do
    1000.times do
      buyer = {
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          gender: Faker::Demographic.sex,
          age: Faker::Number.between(18, 60),
          height: Faker::Demographic.height,
          weight: Faker::Number.between(45, 120),
          marital_status: Faker::Demographic.marital_status,
          children_presence: Faker::Boolean.boolean(0.6),
          job_status: Faker::Job.title,
          job_field: Faker::Job.field,
          profession: Faker::Company.profession,
          education: Buyer.educations.to_a[Faker::Number.between(0, 3)].first,
          pets: Faker::Boolean.boolean(0.3),
          car_presence: Faker::Boolean.boolean(0.9),
          race: Faker::Demographic.race,
          address: Faker::Address.state
      }
      Buyer.create(buyer)
    end
  end
end
