import { cfpDataTable } from '../../base';

$(function() {

  cfpDataTable('.datatable.speaker-list', [ 'text', 'text', 'text', null, 'text' ]);

  $('.dataTables_info').addClass('text-muted');
});
