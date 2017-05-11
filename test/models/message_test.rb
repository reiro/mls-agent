# == Schema Information
#
# Table name: messages
#
#  id            :integer          not null, primary key
#  body          :text
#  user_id       :integer
#  agent_room_id :integer
#  agent_id      :integer
#  sender_type   :integer          default("user")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
