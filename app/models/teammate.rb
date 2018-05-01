class Teammate < ApplicationRecord
  PENDING = "pending".freeze
  ACCEPTED = "accepted".freeze
  DECLINED = "declined".freeze
  STATES = %w[pending accepted declined].freeze

  STAFF_ROLES = ['reviewer', 'program team', 'organizer'].freeze

  ALL = 'all'.freeze
  MENTIONS = 'mentions'.freeze
  IN_APP_ONLY = 'in_app_only'.freeze

  NOTIFICATION_PREFERENCES = {
    ALL => 'All Via Email',
    MENTIONS => 'Mention Only Via Email',
    IN_APP_ONLY => 'In App Only'
  }.freeze

  belongs_to :event
  belongs_to :user

  validates :email, uniqueness: { scope: :event }
  validates :mention_name, uniqueness: { scope: :event, allow_blank: true }
  validates :email, :event, :role, presence: true
  validates :email, format: { with: /@/ }
  validates :mention_name, format: { with: /\A\w+\z/, message: "cannot include punctuation or spaces", allow_blank: true }

  scope :for_event, ->(event) { where(event: event) }
  scope :alphabetize, -> { Teammate.joins(:user).merge(User.order(name: :asc)) }
  scope :notify, -> { where(notifications: true) }

  scope :organizer, -> { where(role: "organizer") }
  scope :program_team, -> { where(role: ["program team", "organizer"]) }
  scope :reviewer, -> { where(role: ["reviewer", "program team", "organizer"]) }

  scope :pending, -> { where(state: PENDING) }
  scope :accepted, -> { where(state: ACCEPTED) }
  scope :active, -> { where(state: ACCEPTED) }
  scope :declined, -> { where(state: DECLINED) }
  scope :invitations, -> { where(state: [PENDING, DECLINED]) }

  scope :all_emails, -> { where(notification_preference: ALL) }

  def accept(user)
    self.user = user
    self.accepted_at = Time.current
    self.state = ACCEPTED
    save
  end

  def decline
    self.declined_at = Time.current
    self.state = DECLINED
    save
  end

  def name
    user ? user.name : ""
  end

  def ratings_count(current_event)
    user.ratings.not_withdrawn.for_event(current_event).size
  end

  def pending?
    state == PENDING
  end

  def invite
    self.token = Digest::SHA1.hexdigest(Time.current.to_s + email + rand(1000).to_s)
    self.state = PENDING
    self.invited_at = Time.current
    save
  end

  def comment_notifications
    if notifications
      "\u2713"
    else
      "X"
    end
  end
end

# == Schema Information
#
# Table name: teammates
#
#  id                      :integer          not null, primary key
#  event_id                :integer
#  user_id                 :integer
#  role                    :string
#  email                   :string
#  state                   :string
#  token                   :string
#  invited_at              :datetime
#  accepted_at             :datetime
#  declined_at             :datetime
#  created_at              :datetime
#  updated_at              :datetime
#  notification_preference :string           default("all")
#  mention_name            :string
#
# Indexes
#
#  index_teammates_on_event_id  (event_id)
#  index_teammates_on_user_id   (user_id)
#
