import { cfpDataTable } from '../base';

$(function() {
  cfpDataTable('.users.datatable', ['text', 'text']);
  $('.dataTables_info').addClass('text-muted');
});
