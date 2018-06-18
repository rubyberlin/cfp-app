$(function() {
  var preview = $('#proposal-preview');
  if (preview.length > 0) {
    var url = preview.data('remote-url');
    $('.watched').on('blur', function() {
      $.ajax({
        data: {
          id: this.id,
          text: $(this).val()
        },
        url: url
      });
    });
  }

  $('.js-maxlength-alert').on('keyup', function() {
    var maxlength = $(this).attr('maxlength');
    var current_length = $(this).val().length;
    if (current_length > maxlength) {
      alert('Character limit of ' + maxlength + ' has been exceeded');
    }
  });

  $('.speaker-invite-button').on('click', () => {
    $('.speaker-invite-form').toggle();
  });

  // Track editing
  $('#edit-track-icon').on('click', () => {
    $('#current-track').addClass('d-none');
    $('#edit-track-wrapper').removeClass('d-none');
  });

  $('#cancel-track-editing').on('click', () => {
    $('#edit-track-wrapper').addClass('d-none');
    $('#current-track').removeClass('d-none');
  });

  // Format editing
  $('#edit-format-icon').on('click', () => {
    $('#current-format').addClass('d-none');
    $('#edit-format-wrapper').removeClass('d-none');
  });

  $('#cancel-format-editing').on('click', () => {
    $('#edit-format-wrapper').addClass('d-none');
    $('#current-format').removeClass('d-none');
  });

  // Reviewer tags editing
  $('#edit-tags-icon').on('click', () => {
    $('.proposal-reviewer-tags, #edit-tags-icon').addClass('d-none');
    $('#review-tags-form-wrapper').removeClass('d-none');
  });

  $('#cancel-tags-editing').on('click', () => {
    $('#review-tags-form-wrapper').addClass('d-none');
    $('.proposal-reviewer-tags, #edit-tags-icon').removeClass('d-none');
  });

  if ($('#autocomplete-options').length > 0) {
    const data = $('#autocomplete-options').data('review-tags');
    const items = data.map(x => ({ item: x }));

    $('#proposal_review_tags').selectize({
      delimiter: ',',
      persist: false,
      plugins: ['remove_button'],
      options: items,
      valueField: 'item',
      labelField: 'item',
      searchField: 'item',
      create: function(input) {
        return {
          value: input,
          text: input,
          item: input
        };
      }
    });
  }
});
