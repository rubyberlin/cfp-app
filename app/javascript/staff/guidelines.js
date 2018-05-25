$(document).ready(function() {

  $('.guidelines-form').hide();

  $('.edit-guidelines-btn').on('click', () => {
    $('.guidelines-form').show();
    $('.guidelines-preview').hide();
    $('.edit-guidelines-btn').hide();
  });

  $( ".edit-guidelines-btn").on('click', () => {
    $( "#text-box" ).focus();
  });

});
