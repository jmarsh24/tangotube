// filters_controller.js
import { Controller } from "stimulus";
// import Rails from "@rails/ujs";

export default class extends Controller {
  static targets = ["filter"];

  connect() {
    console.log('Filter-Controller ON')
  }

  filter() {
    console.log(this.params)
    const url = `${window.location.pathname}?${this.params}`;
    Turbolinks.clearCache();
    Turbolinks.visit(url);
  }

  // filter() {
  //   const url = `${window.location.pathname}?${this.params}`;

  //   Rails.ajax({
  //    type: "get",
  //    url: url,
  //    success: (data) => {
  //      const newContainer = data.getElementById("videos");
  //      const container = document.getElementById("videos");

  //      container.innerHTML = newContainer.innerHTML;
  //    },
  //    error: (data) => {
  //      console.log(data)
  //    }
  //  });
  // }

  get params() {
    // return this.filterTargets.map((t) => `${t.name}=${t.value}`).join("&");
    return this.filterTargets.filter(t => t.value !== "all").map((t) => `${t.name}=${t.value}`).join("&");
  }
}
