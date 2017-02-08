class Event < ApplicationRecord
  belongs_to :user
  belongs_to :address
  has_many :event_guests
  has_many :users, through: :event_guests

  validates :name, :event_date, presence: true

  has_attached_file :cover_photo, styles: { large: "1368x500>", medium: "800x400>", small: "500x300>" }, default_url: "/images/:style/cover_photo.png"
  validates_attachment_content_type :cover_photo, content_type: /\Aimage\/.*\z/
end
