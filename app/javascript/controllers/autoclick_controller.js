import { Controller } from "@hotwired/stimulus";
import { useIntersection } from "stimulus-use";

// Connects to data-controller="autoclick"
export default class extends Controller {
  options = {
    threshold: 1,
  };

  connect() {
    useIntersection(this, this.options);
  }

  appear(entry) {
    this.element.click();
  }
}
