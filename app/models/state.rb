# == Schema Information
#
# Table name: states
#
#  id          :integer          not null, primary key
#  city        :string
#  state_short :string
#  state_full  :string
#  alias       :string
#  county      :string
#

class State < ApplicationRecord

  def search_address
    "#{city}_#{state_short}"
  end
end
