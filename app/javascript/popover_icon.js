$(function() {
  $('body').popover({
    selector: "[data-toggle~='popover']",
    html: true,
    trigger: 'manual'
  });

  // Manually show the popover for clicked-on element, and dismiss all
  // other popovers when new one displayed.
  $(document).on('click', '.popover-trigger', function(ev) {
    const selector = $(this).data('target');
    const toggle = $(selector);
    $.each($("[data-toggle~='popover']"), function(i, pop) {
      pop = $(pop);
      if (pop.is(toggle)) {
        pop.popover('toggle');
        const popover = pop.data('bs.popover')
        $(popover.getTipElement()).addClass('active-popover');
      } else {
        pop.popover('hide');
      }
    });
  });
});
