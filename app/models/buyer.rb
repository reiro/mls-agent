# == Schema Information
#
# Table name: buyers
#
#  id                :integer          not null, primary key
#  first_name        :string
#  last_name         :string
#  gender            :integer
#  age               :integer          default(0)
#  height            :float
#  weight            :float
#  marital_status    :integer          default(0)
#  children_presence :boolean          default(FALSE)
#  job_status        :string
#  job_field         :string
#  profession        :string
#  education         :integer          default(0)
#  pets              :boolean          default(FALSE)
#  car_presence      :boolean
#  race              :integer          default(0)
#  address           :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Buyer < ApplicationRecord
  enum gender: [:'Female', :'Male']
  enum race: [:'White', :'Asian', :'Black or African American', :'Native Hawaiian or Other Pacific Islander', :'American Indian or Alaska Native']
  enum marital_status: [:'Married', :'Separated', :'Never married', :'Divorced', :'Widowed']
  enum education: [:"Bachelor's degree", :'Professional degree', :'Some college', :'12th grade - No Diploma']


  def full_address
    [full_street, city, state].reject(&:blank?).map(&:capitalize).join(' ')
  end
end
