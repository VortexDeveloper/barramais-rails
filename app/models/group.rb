class Group < ApplicationRecord
  belongs_to :user
  has_many :group_members
  has_many :users, through: :group_members

  validates :name, presence: true

  has_attached_file :cover_photo, styles: { large: "1368x500>", medium: "800x400>", small: "500x300>" }, default_url: "/images/:style/cover_photo.png"
  validates_attachment_content_type :cover_photo, content_type: /\Aimage\/.*\z/
end
