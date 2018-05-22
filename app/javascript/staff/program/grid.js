(function($, window) {
  if (typeof(window.Schedule) === 'undefined') {
    window.Schedule = {};
  }
  if (typeof(window.Schedule.Grid) !== 'undefined') {
    return window.Schedule.Grid;
  }

  // Grid properties
  var dayStart = 60*9;  // minutes
  var dayEnd = 60*19;
  const step = 60;
  const verticalScale = 2.5;

  var trackCssClasses = [];
  var trackColors = [];

  function init() {
    var $grids = $('.schedule-grid');
    if ($grids.length == 0) {
      return;
    }
    initTrackColors();
    addGridLineStyle();
    updateDayRange($grids);
    initGrid($grids);
  }

  function updateDayRange($grids) {
    times = _.flatten(_.map($grids.find('.time-slot').toArray(), function(ts) {
        return [$(ts).data("starts"), ($(ts).data("starts") + $(ts).data("duration"))]
    }));

    dayStart = _.min([dayStart, _.min(times)]);
    dayEnd = _.max([dayEnd, _.max(times)]);
  }

  function initGrid($grid) {
    $grid.find('.time-slot').each(function(i, slot) {
      initTimeSlot($(slot));
    });
    $grid.find('.ruler').each(function(i, ruler) {
      initRuler($(ruler));
    });
  }

  function initGridDay(day) {
    var $grid = $('#schedule_day_' + day)
    updateDayRange($grid);
    initGrid($grid);
  }

  function initTimeSlot($slot) {
    $slot.css({
      height: ($slot.data('duration') * verticalScale) + 'px',
      top: (($slot.data('starts') - dayStart) * verticalScale) + 'px'
    });
    assignSizeClass($slot.find('.draggable-session-card, .custom-session-card'), $slot)
    assignTrackColor($slot.find('.draggable-session-card, .custom-session-card'))

    if (!$slot.hasClass('preview')) {
      $slot.click(onTimeSlotClick);
    }

    $slot.droppable({
        accept: '.draggable-session-card',
        hoverClass: 'draggable-hover',
        drop: function(event, ui) {
            var $sessionCard = $(ui.draggable)
            $sessionCard.detach().removeAttr('style').appendTo(this)
            assignSizeClass($sessionCard, $(this))
            assignTrackColor($sessionCard)
            if ($sessionCard.data('scheduled')) {
                window.Schedule.Drag.unschedule($sessionCard)
            }
            updateTimeSlot($(this), $sessionCard)
        }
    })
  }

  function assignTrackColor($element) {
    var trackCss = $element.data('trackCss')
    var i = trackCssClasses.indexOf(trackCss)
    if (i >= 0) {
        $element.find('.track').css({
            backgroundColor: '#' + trackColors[i],
            color: "white"
        })
    }
  }

  function assignSizeClass($sessionCard, $slot) {
      var slotHeight = $slot.height()
      if (slotHeight < 70) {
          $sessionCard.addClass('small')
      } else if (slotHeight < 140) {
          $sessionCard.addClass('medium')
      } else {
          $sessionCard.addClass('large')
      }

  }

  function initRuler($ruler) {
    var m = moment().startOf('day').minutes(dayStart-step);

    for (var i=dayStart; i<=dayEnd; i+=step) {
      $ruler.append('<li>'+ m.minutes(step).format('hh:mma') +'</li>');
    }
  }

  function initTrackColors() {
    trackCssClasses = $('#schedule').data('tracks-css');
    trackColors = palette('tol-rainbow', trackCssClasses.length);
  }

  function addGridLineStyle() {
    // The ruler's ticks are extended by changing their width dynamically.
    var $columns = $('.schedule-grid:first').find('.room-column');
    var lineWidth = $columns.length * $columns.width() + 10;
    $('<style>.schedule-grid .ruler li:after { width: '+lineWidth+'px; }</style>').appendTo('head');
  }

  function updateTimeSlot($timeSlot, $dragged_session) {
    $.ajax({
        url: $timeSlot.data('updatePath'),
        method: 'patch',
        data: {
            time_slot: { program_session_id: $dragged_session.data('id') }
        }
    })
  }

  function initBulkCreateDialog($dialog) {
    var $format = $dialog.find('select.session-format');
    var $duration = $dialog.find('.time-slot-duration');

    $format.change(function(ev) {
      $duration.val($format.val());
    });
    $duration.keyup(function(ev) {
      if ($duration.is(':focus')) {
        $format.val('');
      }
    });
  }

  function onTimeSlotClick(ev) {
    var url = $(this).data('editPath');
    if (url == null || url.length==0) {
      return;
    }

    $.ajax({ url: url });
  }

  window.Schedule.Grid = {
    init: init,
    initGridDay: initGridDay,
    initTimeSlot: initTimeSlot,
    initBulkDialog: initBulkCreateDialog
  };

})(jQuery, window);

$(function() {
  window.Schedule.Grid.init();
});
