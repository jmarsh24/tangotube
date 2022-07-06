import { Controller } from "stimulus";
import TomSelect from "tom-select";

// Connects to data-controller="tom-select"
export default class extends Controller {
  connect() {
    this.control = new TomSelect(this.element, {
      plugins: ["clear_button"],
      maxOptions: 100,
      create: false,
      maxItems: 1,
      persist: false,
      sortField: [{ field: "$order" }],
    });
  }

  disconnect() {
    if (this.control) this.control.destroy();
  }
}
