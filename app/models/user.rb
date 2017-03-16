class User < ApplicationRecord
  # ASSOCIATIONS
  belongs_to :partner, class_name: User, optional: true

  has_one :advertiser

  has_many :groups
  has_many :events
  has_many :posts
  has_many :event_invitations, foreign_key: "guest_id", class_name: "EventGuest"
  has_many :messages
  has_many :conversations, foreign_key: :sender_id

  # VENDOR METHODS

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"

  # ENUMS
  enum relationship: [:single, :serious_relationship, :married]

  # VALIDATIONS
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
  validates :first_name, :last_name, presence: true
  validates_date :birthday, on_or_before: 18.years.ago, on: :create
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

  scope :all_by,      ->(event) {joins(:event_invitations).where(event_guests: {event_id: event.id})}
  scope :pending_by,  ->(event) {joins(:event_invitations).where(event_guests: {event_id: event.id, status: 0})}
  scope :accepted_by, ->(event) {joins(:event_invitations).where(event_guests: {event_id: event.id, status: 1})}
  scope :refused_by,  ->(event) {joins(:event_invitations).where(event_guests: {event_id: event.id, status: 2})}

  def create_post(post_params)
    posts.create(post_params)
  end

  def confirmed_events
    Event.accepted_by(self)
  end

  def refused_events
    Event.refused_by(self)
  end

  def pending_events
    Event.pending_by(self)
  end

  def accept_event event
    event_invitations.where(event: event).first.accept!
  end

  def refuse_event event
    event_invitations.where(event: event).first.refuse!
  end

  def initiated_conversations
    conversations = Conversation.where("sender_id = :user_id OR recipient_id = :user_id", user_id: id).includes(:messages)
    conversations.sort { |c| c.last_message.created_at }
  end

  def is_participant? conversation
    conversation.sender == self || conversation.recipient == self
  end
end
