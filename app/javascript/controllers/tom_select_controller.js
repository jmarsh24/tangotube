import { Controller } from "stimulus";
import TomSelect from "tom-select";

// Connects to data-controller="tom-select"
export default class extends Controller {
  static values = {
    create: { type: Boolean, default: false },
  };

  connect() {
    this.control = new TomSelect(this.element, {
      plugins: ["clear_button"],
      maxOptions: 100,
      create: this.createValue,
      // maxItems: 1,
      persist: false,
      sortField: [{ field: "$order" }],
    });
  }

  disconnect() {
    if (this.control) this.control.destroy();
  }
}
