class Message < ApplicationRecord
  belongs_to :user
  belongs_to :agent_room
  belongs_to :agent

  # validates :body, presence: true, length: { minimum: 1, maximum: 1000 }

  default_scope { order(created_at: :asc) }

  enum sender_type: [:user, :agent]

  after_create_commit { MessageBroadcastJob.perform_later(self) }

  def timestamp
    created_at.strftime('%H:%M:%S %d %B %Y')
  end
end
