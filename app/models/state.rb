class State < ApplicationRecord

  def search_address
    "#{city}_#{state_short}"
  end
end
