class Staff::ProgramSessionDecorator < ApplicationDecorator
  decorates_association :speakers
  delegate_all

  def state_badge(large: false, state: nil)
    state ||= self.state

    classes = "badge #{state_class(state)}"
    classes += ' badge-large' if large

    h.content_tag :span, state, class: classes
  end

  def confirmation_notes_link
    return '' unless object.confirmation_notes?
    id = h.dom_id(object, 'notes')
    h.link_to h.event_staff_program_session_path(object.event, object) do
      h.content_tag(:i, '', class: 'fa fa-file')
    end
  end

  def state_class(state)
    case state
    when ProgramSession::LIVE
      'badge-success'
    when ProgramSession::DRAFT
      'badge-secondary'
    when ProgramSession::UNCONFIRMED_ACCEPTED
      'badge-info'
    when ProgramSession::UNCONFIRMED_WAITLISTED
      'badge-warning'
    when ProgramSession::CONFIRMED_WAITLISTED
      'badge-warning'
    when ProgramSession::DECLINED
      'badge-danger'
    else
      'badge-secondary'
    end
  end

  def track_name
    object.track_name || Track::NO_TRACK
  end

  def format_name
    object.session_format.name
  end

  def display_speakers
    object.speakers.pluck(:speaker_name).join(", ")
  end

  def ps_data
    data = {
      track_css: track_name.try(:parameterize),
      id: object.id
    }
    if object.time_slot
      data[:scheduled] = object.time_slot.id
      data[:unschedule_time_slot_path] = h.event_staff_schedule_grid_time_slot_url(object.event, object.time_slot)
    end
    data
  end

  def abstract_markdown
    h.markdown(object.abstract)
  end

  def scheduled_for
    if object.time_slot
      ts = object.time_slot
      "Day #{ts.conference_day}" if ts.conference_day.present?
    end
  end

  def complete_video_url
    if object.video_url[/^https?:\/\//]
      object.video_url
    else
      "http://#{object.video_url}"
    end
  end

  def complete_slides_url
    if object.slides_url[/^https?:\/\//]
      object.slides_url
    else
      "http://#{object.slides_url}"
    end
  end
end
