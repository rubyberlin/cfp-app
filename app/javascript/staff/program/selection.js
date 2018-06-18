import { cfpDataTable } from '../../base';

$(function() {
  cfpDataTable('#organizer-proposals-selection.datatable', [
    'text',
    'text',
    'text',
    null,
    'text',
    'text',
    'text',
    'text'
  ]);

  setupPopovers();

  $(document).on('change', '.proposal-track-select', onProposalTrackChange);
  $(document).on('change', '.proposal-format-select', onProposalFormatChange);

  function onProposalTrackChange(ev) {
    removePopover('track');
    const $trackSelect = $(this);
    const trackId = $trackSelect.val();
    const url = $trackSelect.data('targetPath');

    $trackSelect.closest('div').load(url, { track_id: trackId }, response => {
      updateProposalSelect(response, 'track', trackId);
    });
  }

  function onProposalFormatChange(ev) {
    removePopover('format');
    const $formatSelect = $(this);
    const formatId = $formatSelect.val();

    const url = $formatSelect.data('targetPath');

    $formatSelect
      .closest('div')
      .load(url, { session_format_id: formatId }, response => {
        updateProposalSelect(response, 'format', formatId);
      });
  }

  function updateProposalSelect(response, selectName, newId) {
    const html = $.parseHTML(response);
    const opt = $(`option[value='${newId}']`, html).text();
    $(`#${selectName}-name`).html(opt);
    $(`#edit-${selectName}-wrapper`).addClass('d-none');
    $(`#current-${selectName}`).removeClass('d-none');
    setupPopovers();
  }

  function setupPopovers() {
    $('[data-toggle="popover"]').popover({
      container: 'body'
    });
  }

  function removePopover(selectName) {
    const targetId = $(`#edit-${selectName}-wrapper`)
      .find('select')
      .attr('aria-describedby');
    $(`#${targetId}`).remove();
  }
});
