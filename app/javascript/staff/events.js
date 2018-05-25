$(function() {
  $('.status-button').on('click', () => {
    $('.status-dropdown').show();
    $('.btn-nav').hide();
  });

  $('.cancel-status-change').on('click', () => {
    $('.status-dropdown').hide();
    $('.btn-nav').show();
  });
});
