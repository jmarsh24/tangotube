// filters_controller.js
import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["filter"];

  connect() {
    console.log('Filter-Controller ON')
  }

  filter() {
    const url = `${window.location.pathname}?${this.params}`;
    Turbolinks.clearCache();
    Turbolinks.visit(url);
  }

  get params() {
    // return this.filterTargets.map((t) => `${t.name}=${t.value}`).join("&");
    return this.filterTargets.filter(t => t.value !== "all").map((t) => `${t.name}=${t.value}`).join("&");
  }
  
}
