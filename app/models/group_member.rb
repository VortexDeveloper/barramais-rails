class GroupMember < ApplicationRecord
  belongs_to :user
  belongs_to :group
  enum accepted: [:s, :n]
end
