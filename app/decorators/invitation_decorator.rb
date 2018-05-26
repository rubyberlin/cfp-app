class InvitationDecorator < ApplicationDecorator
  delegate_all
  decorates_association :proposal

  STATE_BADGE_MAP = {
    Invitation::State::PENDING => 'badge-secondary',
    Invitation::State::DECLINED => 'badge-danger',
    Invitation::State::ACCEPTED => 'badge-success'
  }.freeze

  def decline_button(small: false)
    classes = 'btn btn-danger'
    classes += ' btn-sm' if small

    h.link_to 'Decline',
              h.decline_invitation_path(object.slug),
              class: classes,
              data: { confirm: 'Are you sure you want to decline this invitation?' }
  end

  def accept_button(small: false)
    classes = 'btn btn-success'
    classes += ' btn-sm' if small

    h.link_to 'Accept',
              h.accept_invitation_path(object.slug),
              class: classes
  end

  def state_badge
    h.content_tag :span, object.state,
                  class: "badge #{STATE_BADGE_MAP[object.state]}"
  end
end
