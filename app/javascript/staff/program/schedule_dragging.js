import palette from 'google-palette';

(function($, window) {
    if (typeof(window.Schedule) === 'undefined') {
        window.Schedule = {}
    }
    if (typeof(window.Schedule.Drag) !== 'undefined') {
        return window.Schedule.Drag
    }

    let trackCssClasses = [];
    let trackColors = [];

    function init() {
        if ($(".unscheduled-sessions").length ) {
            $('.unscheduled-sessions-toggle').on('click', toggleUnscheduledSessionsWidget)
            $('input[name="session_search"]').on('keyup', filterSessions)

            initTrackColors()
            initDraggableSessions()
            initDroppableSessionsWidget()
        }
    }

    function toggleUnscheduledSessionsWidget(e) {
        e.preventDefault()
        $('.unscheduled-sessions-widget, .search-sessions-wrapper').toggleClass('d-none')
    }

    function filterSessions() {
        var query = this.value.toLowerCase()
        var items = $('.unscheduled-sessions-widget .draggable-session-card')

        for (var i = 0; i < items.length; i++) {
            var itemText = $(items[i]).text().toLowerCase()
            if (itemText.indexOf(query) > -1) {
                $(items[i]).removeClass('d-none')
            } else {
                $(items[i]).addClass('d-none')
            }
        }
    }

    function initTrackColors() {
        trackCssClasses = $('#schedule').data('tracks-css');
        trackColors = palette('tol-rainbow', trackCssClasses.length);
    }

    function initDraggableSessions() {
        var $sessions = $('.draggable-session-card')
        $sessions.each(function(i, session) {
            initDraggableSession($(session))
        })
    }

    function initDraggableSession($session) {
        var trackCss = $session.data('trackCss')
        var i = trackCssClasses.indexOf(trackCss)
        if (i >= 0) {
            $session.find('.track').css({
                backgroundColor: '#' + trackColors[i]
            })
        }
        $session.draggable({
            helper: 'clone',
            revertDuration: 100,
            revert: 'invalid',
            appendTo: 'body',
            scroll: false,
            start: function(event, ui) {
                $(ui.helper).css({ backgroundColor: 'white' })
            }
        })
    }

    function initDroppableSessionsWidget() {
        $('.unscheduled-sessions-widget').droppable({
            accept: '.draggable-session-card',
            drop: function(event, ui) {
                $(ui.draggable).detach().removeAttr('style').prependTo(this)
                $(ui.draggable).removeClass('small medium large')
                if ($(ui.draggable).data('scheduled')) {
                    unschedule($(ui.draggable))
                }
            }
        })
    }

    function unschedule($removed) {
        $.ajax({
            url: $removed.data('unscheduleTimeSlotPath'),
            method: 'patch',
            data: { time_slot: { program_session_id: '' } }
        })
    }

    window.Schedule.Drag = {
        init: init,
        initDraggableSession: initDraggableSession,
        unschedule: unschedule,
    }


}) (jQuery, window)

$(function() {
    window.Schedule.Drag.init()
})
