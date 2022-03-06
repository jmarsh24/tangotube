import { Controller } from "@hotwired/stimulus";
import { createPopper } from "@popperjs/core";
import { useClickOutside } from "stimulus-use";

export default class extends Controller {
  static targets = ["element", "tooltip"];
  static values = {
    placement: String,
    offset: Array,
  };

  initialize() {
    this.placementValue = "top";
    this.offsetValue = [0, 8];
  }

  connect() {
    useClickOutside(this);

    // Create a new Popper instance
    this.popperInstance = createPopper(this.elementTarget, this.tooltipTarget, {
      placement: this.placementValue,
      modifiers: [
        {
          name: "offset",
          options: {
            offset: this.offsetValue,
          },
        },
      ],
    });
  }

  clickOutside() {
    this.hide();
  }

  show(event) {
    event.preventDefault();
    this.hideAllElements();
    this.tooltipTarget.setAttribute("data-show", "");

    // We need to tell Popper to update the tooltip position
    // after we show the tooltip, otherwise it will be incorrect
    this.popperInstance.update();
  }

  hide() {
    this.tooltipTarget.removeAttribute("data-show");
  }

  hideAllElements() {
    document
      .querySelectorAll("#tooltip")
      .forEach((element) => element.removeAttribute("data-show"));
  }

  // Destroy the Popper instance
  disconnect() {
    if (this.popperInstance) {
      this.popperInstance.destroy();
    }
  }
}
