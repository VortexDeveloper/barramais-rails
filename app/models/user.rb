class User < ApplicationRecord
  # ASSOCIATIONS
  belongs_to :partner, class_name: User, optional: true

  has_one :advertiser
  has_many :classifieds

  has_many :groups
  has_many :events
  has_many :posts, dependent: :destroy
  has_many :event_invitations, foreign_key: "guest_id", class_name: "EventGuest"
  has_many :group_invitations, foreign_key: "member_id", class_name: "GroupMember"
  has_many :messages
  has_many :conversations, foreign_key: :sender_id
  has_many :own_vessels

  #FRIENDSHIP
  has_many :friendships
  has_many :friends, :through => :friendships
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user

  # VENDOR METHODS

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable

  acts_as_voter

  has_attached_file :avatar, styles: {
    medium: "300x300>",
    thumb: "100x100>"
  }, default_url: "/images/:style/usermissing.png"

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
    :capitao_amador,
    :sem_interesse
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

  #Event Actions

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

  #Group Actions

  #Eventos em que este usuário está na lista de membros com o status aceito
  def confirmed_groups
    GroupMember.where(member: self, status: 1).map { |f| f.group }
  end

  #Eventos em que este usuário está na lista de membros com o status recusado
  def refused_groups
    GroupMember.where(member: self, status: 2).map { |f| f.group }
  end

  #Eventos em que este usuário está na lista de membros com o status pendente
  def pending_groups
    GroupMember.where(member: self, status: 0).map { |f| f.group }
  end

  #Aceitar convite do grupo passado por parametro
  def accept_group group
    group_invitations.where(group: group).first.accept!
  end

  #Recusar convite do grupo passado por parametro
  def refuse_group group
    group_invitations.where(group: group).first.refuse!
  end

  #Conversations Actions

  def initiated_conversations
    conversations = Conversation.where("sender_id = :user_id OR recipient_id = :user_id", user_id: id).includes(:messages)
    conversations.sort { |c| c.last_message.created_at }
  end

  def is_participant? conversation
    conversation.sender == self || conversation.recipient == self
  end

  # FRIENDSHIP SEARCHES

  def accepted_friendships
    friends.where(friendships: { status: :accept })
  end

  def refused_friendships
    friends.where(friendships: { status: :refuse })
  end

  def pending_friendships
    Friendship.where(friend: self, status: :pending).map { |f| f.user }
  end

  def all_friends
    friends
  end

  # FRIENDSHIP ACTIONS

  def request_friendship_of friend
    friends << friend
  end

  def accept_friendship_of friend
    friendship_request_of(friend).accept!
  end

  def refuse_friendship_of friend
    friendship_request_of(friend).refuse!
  end

  def friend_of? user
    if friends.include?(user) && friendship_between(user).pending?
      "waiting"
    else
      friends.include?(user) && friendship_between(user).accept?
    end
  end

  def unfriend friend
    friends.destroy friend
  end

  def friendship_request_sent? user
    friends.include?(user) && friendship_between(user).pending?
  end

  def user_hash
    user_h ||= self.as_json
    user_h.merge!({avatar_url: ApplicationController.helpers.asset_url(avatar.url)})
    own_vessels_hash = own_vessels.reload.map do |own_vessel|
      {id: own_vessel.vessel_type.id}.merge!({vessel_type_name: own_vessel.vessel_type.name})
    end
    user_h[:own_vessels] = own_vessels_hash
    user_h
  end

  def save_own_vessels(new_own_vessels_id)
    own_vessels.each do |ov|
      ov.destroy unless new_own_vessels_id.include?(ov.vessel_type_id)
    end
    new_own_vessels_id.each do |new_own_vessel_id|
      own_vessels.create(vessel_type_id: new_own_vessel_id)
    end
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

  def friendship_request_of friend
    Friendship.where(user: friend, friend: self).first
  end

  def friendship_between friend
    friendships.where(friend: friend).first
  end
end
