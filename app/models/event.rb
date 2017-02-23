class Event < ApplicationRecord
  belongs_to :user
  belongs_to :address
  has_many :event_guests
  has_many :guests, through: :event_guests

  validates :name, :event_date, presence: true

  has_attached_file :cover_photo, styles: { large: "1368x500>", medium: "800x400>", small: "500x300>" }, default_url: "/images/:style/cover_photo.png"
  validates_attachment_content_type :cover_photo, content_type: /\Aimage\/.*\z/

  scope :accepted_by, ->(user) {join_to_user(user).where(event_guests: {status: :accept})}
  scope :refused_by, ->(user) {join_to_user(user).where(event_guests: {status: :refuse})}
  scope :pending_by, ->(user) {join_to_user(user).where(event_guests: {status: :pending})}

  def confirmed_guests
    User.accepted_by(self)
  end

  def refused_guests
    User.refused_by(self)
  end

  def pending_guests
    User.pending_by(self)
  end

  def all_guests
    User.all_by(self)
  end

  private

  def self.join_to_user user
    joins(:event_guests, :user).where(users: {id: user.id})
  end

end
