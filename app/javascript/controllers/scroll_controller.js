import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="scroll"
export default class extends Controller {
  connect() {
    console.log(this.element);
    this.element.addEventListener("wheel", (event) => {
      event.preventDefault();
      this.element.scrollBy({
        left: event.deltaY < 0 ? -30 : 30,
      });
    });
  }
}
