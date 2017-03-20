class Friendship < ApplicationRecord

  before_save :initialize_status
  belongs_to :user
  belongs_to :friend, :class_name => "User"

  enum status: [
    :pending,
    :accept,
    :refuse
  ]

  def initialize_status
    self.status = :pending if self.status.nil?
  end

end
