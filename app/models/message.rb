class Message < ApplicationRecord
  belongs_to :user
  belongs_to :conversation

  after_create_commit { MessageBroadcastJob.perform_later(self) }

  def sent_date_format
    if created_at.today?
      created_at.to_formatted_s :time
    elsif created_at.between?(1.week.ago, Date.current)
      created_at.strftime("%a")
    else
      created_at.strftime("%d %b")
    end
  end
end
