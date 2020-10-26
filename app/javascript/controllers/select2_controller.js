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
      searchInputPlaceholder: 'Select filter below or search by keyword',
      width: 'resolve',
      dropdownPosition: 'below'
      }).on("select2:closing", function(e) {
        e.preventDefault();
      }).on("select2:closed", function(e) {
        list.select2("open");
      }).on("select2:select", function() {
        let event = new Event('change', { bubbles: true })
        this.dispatchEvent(event)
      }).select2("open");
    }
  }