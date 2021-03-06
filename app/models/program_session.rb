class ProgramSession < ApplicationRecord
  LIVE = 'live'.freeze # confirmed accepted
  DRAFT = 'draft'.freeze # created by organizer, not ready to be published (live)
  UNCONFIRMED_ACCEPTED = 'unconfirmed accepted'.freeze # accepted, to be confirmed by speaker
  UNCONFIRMED_WAITLISTED = 'unconfirmed waitlisted'.freeze
  CONFIRMED_WAITLISTED = 'confirmed waitlisted'.freeze
  DECLINED = 'declined'.freeze

  STATES = [
    LIVE,
    DRAFT,
    UNCONFIRMED_ACCEPTED,
    UNCONFIRMED_WAITLISTED,
    CONFIRMED_WAITLISTED,
    DECLINED
  ].freeze

  STATE_GROUPS = {
    LIVE => "program",
    DRAFT => "program",
    UNCONFIRMED_ACCEPTED => "program",
    UNCONFIRMED_WAITLISTED => "waitlist",
    CONFIRMED_WAITLISTED => "waitlist",
    DECLINED => "declined"
  }.freeze

  PROMOTIONS = {
    DRAFT => LIVE,
    UNCONFIRMED_WAITLISTED => UNCONFIRMED_ACCEPTED,
    CONFIRMED_WAITLISTED => LIVE
  }.freeze

  CONFIRMATIONS = {
    UNCONFIRMED_WAITLISTED => CONFIRMED_WAITLISTED,
    UNCONFIRMED_ACCEPTED => LIVE
  }.freeze

  belongs_to :event
  belongs_to :proposal
  belongs_to :track
  belongs_to :session_format
  has_one :time_slot
  has_many :speakers

  accepts_nested_attributes_for :speakers
  accepts_nested_attributes_for :proposal

  validates :event, :session_format, :title, :state, presence: true

  validates :state, inclusion: { in: STATES }

  serialize :info, Hash

  after_destroy :destroy_speakers

  scope :unscheduled, -> do
    where(state: LIVE).where.not(id: TimeSlot.pluck(:program_session_id))
  end
  scope :sorted_by_title, -> { order(:title) }
  scope :live, -> { where(state: LIVE) }
  scope :draft, -> { where(state: DRAFT) }
  scope :waitlisted, -> { where(state: [CONFIRMED_WAITLISTED, UNCONFIRMED_WAITLISTED]) }
  scope :program, -> { where(state: [LIVE, DRAFT, UNCONFIRMED_ACCEPTED]) }
  scope :declined, -> { where(state: DECLINED) }
  scope :without_proposal, -> { where(proposal: nil) }
  scope :in_track, ->(track) do
    track = nil if track.try(:strip).blank?
    where(track: track)
  end
  scope :emails, -> { joins(:speakers).pluck(:speaker_email).uniq }

  def self.create_from_proposal(proposal)
    transaction do
      ps = ProgramSession.create!(event_id: proposal.event_id,
                                  proposal_id: proposal.id,
                                  title: proposal.title,
                                  abstract: proposal.abstract,
                                  track_id: proposal.track_id,
                                  session_format_id: proposal.session_format_id,
                                  state: proposal.waitlisted? ? UNCONFIRMED_WAITLISTED : UNCONFIRMED_ACCEPTED)

      # attach proposal speakers to new program session
      ps.speakers << proposal.speakers
      ps.speakers.each do |speaker|
        (speaker.speaker_name = speaker.user.name) if speaker.speaker_name.blank?
        (speaker.speaker_email = speaker.user.email) if speaker.speaker_email.blank?
        (speaker.bio = speaker.user.bio) if speaker.bio.blank?
        speaker.save!
      end
      ps
    end
  end

  def can_confirm?
    CONFIRMATIONS.keys.include?(state)
  end

  def confirm
    update(state: CONFIRMATIONS[state]) if can_confirm?
  end

  def can_promote?
    PROMOTIONS.keys.include?(state)
  end

  def promote
    update(state: PROMOTIONS[state]) | promote_proposal
  end

  def promote_proposal
    proposal&.promote
  end

  def live?
    state == LIVE
  end

  def multiple_speakers?
    speakers.count > 1
  end

  def speaker_names
    speakers.map(&:name).join(', ')
  end

  def speaker_emails
    speakers.map(&:email).join(', ')
  end

  def session_format_name
    session_format.try(:name)
  end

  def track_name
    track.try(:name)
  end

  def group_name
    STATE_GROUPS[state]
  end

  def confirmation_notes?
    proposal.try(:confirmation_notes?)
  end

  def confirmation_notes
    proposal.try(:confirmation_notes)
  end

  def scheduled?
    time_slot.present?
  end

  def video_url
    info[:video_url]
  end

  def slides_url
    info[:slides_url]
  end

  def video_url=(video_url)
    info[:video_url] = video_url
  end

  def slides_url=(slides_url)
    info[:slides_url] = slides_url
  end

  private

  def destroy_speakers
    speakers.each do |speaker|
      if speaker.proposal_id.present?
        speaker.update(program_session_id: nil)
      else
        speaker.destroy
      end
    end
  end
end

# == Schema Information
#
# Table name: program_sessions
#
#  id                :integer          not null, primary key
#  event_id          :integer
#  proposal_id       :integer
#  title             :text
#  abstract          :text
#  track_id          :integer
#  session_format_id :integer
#  state             :text             default("draft")
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  info              :text
#
# Indexes
#
#  index_program_sessions_on_event_id           (event_id)
#  index_program_sessions_on_proposal_id        (proposal_id)
#  index_program_sessions_on_session_format_id  (session_format_id)
#  index_program_sessions_on_track_id           (track_id)
#
