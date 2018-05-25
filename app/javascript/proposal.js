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
      alert("Character limit of " + maxlength + " has been exceeded");
    }
  });

  $('.speaker-invite-button').on('click', () => {
    $('.speaker-invite-form').toggle();
  });

  // Track editing
  $('#edit-track-icon').on('click', () => {
    $('#current-track').hide();
    $('#edit-track-wrapper').show();
  });

  $('#cancel-track-editing').on('click', () => {
    $('#edit-track-wrapper').hide();
    $('#current-track').show();
  });

  // Format editing
  $('#edit-format-icon').on('click', () => {
    $('#current-format').hide();
    $('#edit-format-wrapper').show();
  });

  $('#cancel-format-editing').on('click', () => {
    $('#edit-format-wrapper').hide();
    $('#current-format').show();
  });

  // Reviewer tags editing
  $('#edit-tags-icon').on('click', () => {
    $('.proposal-reviewer-tags, #edit-tags-icon').toggle();
    $('#review-tags-form-wrapper').slideToggle();
  });

  $('#cancel-tags-editing').on('click', () => {
    $('#review-tags-form-wrapper').toggle();
    $('.proposal-reviewer-tags, #edit-tags-icon').toggle();
  });

  if($('#autocomplete-options').length > 0) {
    var html = $('#autocomplete-options').html();
    var data = JSON.parse(html);
    var items = data.map(function(x) { return { item: x }; });

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
        }
      }
    });
  }
});
