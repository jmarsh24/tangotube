import { Controller } from "stimulus"
import $ from 'jquery';

require("select2/dist/css/select2")

import Select2 from "select2"

export default class extends Controller {
  connect() {
    console.log('Select2 Controller ON')
    var list = $('.content-search').select2({
      closeOnSelect: false,
      dropdownPosition: 'below',
      searchInputPlaceholder: 'Select filter below or search by keyword'
      }).on("select2:closing", function(e) {
        e.preventDefault();
      }).on("select2:closed", function(e) {
        list.select2("open");
      }).on("select2:select", function() {
        let event = new Event('change', { bubbles: true })
        this.dispatchEvent(event)
      }).on('select2-open', function() {

        // however much room you determine you need to prevent jumping
        var requireHeight = 600;
        var viewportBottom = $(window).scrollTop() + $(window).height();

        // figure out if we need to make changes
        if (viewportBottom < requireHeight) 
        {           
            // determine how much padding we should add (via marginBottom)
            var marginBottom = requireHeight - viewportBottom;

            // adding padding so we can scroll down
            $(".aLwrElmntOrCntntWrppr").css("marginBottom", marginBottom + "px");

            // animate to just above the select2, now with plenty of room below
            $('html, body').animate({
                scrollTop: $("#mySelect2").offset().top - 10
            }, 1000);
        }
    }).select2("open");
    }
  }