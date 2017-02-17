class EventGuest < ApplicationRecord
  belongs_to :user
  belongs_to :event
  enum accepted: [:s, :n]
end
