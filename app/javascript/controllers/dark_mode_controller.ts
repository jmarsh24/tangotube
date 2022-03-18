import { Controller } from "@hotwired/stimulus";
import { SlSwitch } from "@shoelace-style/shoelace"

// Connects to data-controller="dark-mode"
export default class extends Controller {
  static targets = ["switch"];

  switchTarget: SlSwitch

  connect() {
    if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
      this.htmlElement.classList.add("sl-theme-dark")
    }

    if (this.htmlElement.classList.contains("sl-theme-dark")) {
      this.switchTarget.setAttribute("checked", "")
    }
  }

  toggle() {
    if (this.switchTarget.checked) {
      this.htmlElement.classList.add("sl-theme-dark")
    } else {
      this.htmlElement.classList.remove("sl-theme-dark")
    }
  }

  get htmlElement() {
    return document.querySelector("html") as HTMLElement
  }
}
