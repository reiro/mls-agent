# == Schema Information
#
# Table name: agent_rooms
#
#  id         :integer          not null, primary key
#  title      :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AgentRoom < ApplicationRecord
  belongs_to :user
  has_many :messages, dependent: :destroy
  has_one :agent

  after_create :create_agent

  private

  def create_agent
    self.build_agent(name: 'Agent Smith').save
  end
end
