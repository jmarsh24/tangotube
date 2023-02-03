import { Controller } from "@hotwired/stimulus";
import { get } from "@rails/request.js";
import TomSelect from "tom-select";

// Connects to data-controller="tom-select-edit"
export default class extends Controller {
  static values = { url: String };

  connect() {
    var config = {
      plugins: ["clear_button"],
      valueField: "value",
      load: (q, callback) => this.search(q, callback),
    };

    new TomSelect(this.element, config);
  }

  async search(q, callback) {
    const response = await get(this.urlValue, {
      query: { q: q },
      responseKind: "json",
    });

    if (response.ok) {
      const list = await response.json;
      callback(list);
    } else {
      console.log(response);
      callback();
    }
  }
}
