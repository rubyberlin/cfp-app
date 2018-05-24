/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

// import $ from 'jquery';
import 'underscore'

import 'jquery-ui/themes/base/core.css'
import 'jquery-ui/themes/base/autocomplete.css'
import 'jquery-ui/themes/base/menu.css'
import 'jquery-ui/themes/base/theme.css'

import 'jquery-ui/themes/base/datepicker.css'
import 'jquery-ui/ui/widgets/datepicker'

import 'jquery-ui/themes/base/slider.css'
import 'jquery-ui/ui/widgets/slider'

import 'jquery-ujs'
import 'bootstrap-sass'

import 'datatables.net-bs/css/dataTables.bootstrap.css'
import datatables from 'datatables.net-bs'
datatables(window, $)

import 'vendor/jquery.dataTables.columnFilter'

$.fn.dataTableExt.oApi.fnSortNeutral = oSettings => {
  oSettings.aaSorting = []
  oSettings.aiDisplay.sort((x, y) => x - y)
  oSettings.aiDisplayMaster.sort((x, y) => x - y)
  oSettings.oApi._fnReDraw(oSettings)
}

import 'jquery-ui-timepicker-addon/dist/jquery-ui-timepicker-addon.css'
import 'jquery-ui-timepicker-addon'

import 'vendor/jquery.mentionsInput.scss'
import 'vendor/jquery.mentionsInput'

import 'bootstrap-multiselect/dist/css/bootstrap-multiselect.css'
import 'bootstrap-multiselect'

import 'moment'

import 'selectize/dist/css/selectize.css'
import 'selectize/dist/css/selectize.default.css'
import 'selectize'

import 'google-palette'

import Chartkick from 'chartkick'
window.Chartkick = Chartkick

import 'vendor/coderay.css.erb'

import 'admin/event_teammates.js'
import 'admin/events.js'
import 'admin/users.js'

import 'base.js'
import 'popover_icon.js'
import 'profile.js'
import 'proposal.js'

import 'staff/emails.js'
import 'staff/events.js'
import 'staff/guidelines.js'
import 'staff/mentions.js'

import 'staff/program/copySpeakerEmails.js'
import 'staff/program/grid.js'
import 'staff/program/program.js'
import 'staff/program/proposals.js'
import 'staff/program/ratings.js'
import 'staff/program/schedule_dragging.js'
import 'staff/program/selection.js'
import 'staff/program/sessions.js'
import 'staff/program/speakers.js'
import 'staff/program/subnav.js'
import 'staff/program/time-slot.js'

import 'staff/proposals.js'
import 'staff/track.js'
import 'staff/utilities.js'

import 'twitter.js'
