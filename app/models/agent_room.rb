class AgentRoom < ApplicationRecord
  belongs_to :user
  has_many :messages, dependent: :destroy
  has_one :agent

  after_create :create_agent

  private

  def create_agent
    self.build_agent.save
  end
end