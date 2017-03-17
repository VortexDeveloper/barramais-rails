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

  has_attached_file :avatar, styles: {
    medium: "300x300>",
    thumb: "100x100>"
  }, default_url: "/images/:style/missing.png"

  # ENUMS
  enum relationship: [
    :single,
    :serious_relationship,
    :married
  ]
  enum nautical_license: [
    :motonauta,
    :arrais_amador,
    :mestre_amador,
    :capitao_amador
  ]
  enum naval_service_patent: [
    :marinheiro,
    :cabo,
    :terceiro_sargento,
    :segundo_sargento,
    :primeiro_sargento,
    :suboficial,
    :segundo_tenente,
    :primeiro_tenente,
    :capitao_tenente,
    :capitao_corveta,
    :capitao_fragata,
    :capitao_mar_guerra,
    :contra_almirante,
    :vice_almirante,
    :almirante_esquadra
  ]


  # VALIDATIONS
  validates :email, format: {
    with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create
  }

  validates :first_name, :last_name, presence: true
  validates_date :birthday, on_or_before: 18.years.ago, on: :create
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
  devise :database_authenticatable, :validatable, password_length: 8..128
  validate :single_word_last_name
  validate :single_word_first_name

  #SCOPES
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

  private

  def single_word_last_name
    if last_name.split.size > 1 || last_name =~ /\d/
      errors.add(:last_name, "deve conter apenas um nome e deve conter apenas letras")
    end
  end

  def single_word_first_name
    if first_name.split.size > 1 || first_name =~ /\d/
      errors.add(:first_name, "deve conter apenas um nome e deve conter apenas letras")
    end
  end
end
