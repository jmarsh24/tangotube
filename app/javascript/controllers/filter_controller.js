// filters_controller.js
import { Controller } from "stimulus";
// import Rails from "@rails/ujs";
import * as Turbo from '@hotwired/turbo';

export default class extends Controller {
  static targets = ["filter"];

  connect() {
    console.log("Filter-Controller ON");
  }

  filter() {
    console.log(window.location.pathname);
    const url = `${window.location.pathname}?${this.params}`;
    Turbo.clearCache();
    Turbo.visit(url);
  }

  // filter() {
  //   const url = `${window.location.pathname}?${this.params}`;

  //   Rails.ajax({
  //    type: "get",
  //    url: url,
  //    success: (data) => {
  //      const newContainerVideos = data.getElementById("videos");
  //      const containerVideos = document.getElementById("videos");
  //      const containerFilters = document.getElementById("filters");
  //      const newContainerFilters = data.getElementById("filters");
  //      containerVideos.innerHTML = newContainerVideos.innerHTML;
  //      containerFilters.innerHTML = newContainerFilters.innerHTML;
  //      history.pushState({}, '', `${window.location.pathname}?${this.params}`)
  //    },
  //    error: (data) => {
  //      console.log(data)
  //    }
  //  });
  // }

  get params() {
    let params = this.filterTargets
      .filter((t) => t.value !== "all")
      .map((t) => `${t.name}=${t.value}`);

    let search = document.querySelector("#query");
    if (search.value) {
    params.push(`${search.name}=${search.value}`)
    }
    return params.join("&");
  }
}
