import { Controller } from "stimulus";
import $ from "jquery";
import Select2 from 'select2'

require("select2/dist/css/select2");
require("select2-dropdownPosition/select2-dropdownPosition.js");

export default class extends Controller {
  initialize() {
    console.log("Select2 Controller Connected");
    var list = $(".content-search").select2({
        closeOnSelect: false,
        dropdownPosition: "below",
        searchInputPlaceholder: "Select filter below or search by keyword",
        width: "resolve"
      })
      .on("select2:closing", function (e) {
      e.preventDefault();
    })
    .on("select2:closed", function (e) {
      list.select2("open");
    })
    .on("select2:select", function () {
      let event = new Event("change", { bubbles: true });
      this.dispatchEvent(event);
    }).select2("open");
  }

  open() {
    console.log('Select2 Open')
    var list = $('.content-search').select2({
    closeOnSelect: false,
    dropdownPosition: 'below',
    searchInputPlaceholder: 'Select filter below or search by keyword',
    width: 'resolve'
    })
    .on("select2:closing", function (e) {
      e.preventDefault();
    })
    .on("select2:closed", function (e) {
      list.select2("open");
    })
    .on("select2:select", function () {
      let event = new Event("change", { bubbles: true });
      this.dispatchEvent(event);
    }).select2("open");
  }

  // close() {
  //   console.log('Select2 Close')
  //   var list = $('.content-search').select2("open");
  // }

}
