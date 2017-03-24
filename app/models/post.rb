class Post < ApplicationRecord
  include ActionView::Helpers::DateHelper
  belongs_to :user

  acts_as_votable
  acts_as_commentable

  validates :description, presence: true

  enum domain: [:users, :events, :groups, :pages]

  def sent_date_format
    if created_at.today?
      time_ago_in_words(created_at)
    else
      created_at.strftime("%b, %d %Y - %H:%M")
    end
  end
end
