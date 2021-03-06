import { Controller } from "@hotwired/stimulus";
import { SlSwitch } from "@shoelace-style/shoelace"

// Connects to data-controller="dark-mode"
export default class extends Controller {
  static targets = ["switch"];

  switchTarget: SlSwitch

  connect() {
    const darkModeValue = localStorage.getItem("darkModeStatus");
    const darkModeStatus = JSON.parse(darkModeValue);

    if (darkModeStatus) {
      this.htmlElement.classList.add("sl-theme-dark")
    }

    // if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
    //   this.htmlElement.classList.add("sl-theme-dark")
    // }

    if (this.htmlElement.classList.contains("sl-theme-dark")) {
      this.switchTarget.setAttribute("name", "sun")
    }
  }

  toggle() {
    if (this.htmlElement.classList.contains("sl-theme-dark")) {
      this.htmlElement.classList.remove("sl-theme-dark")
      localStorage.setItem('darkModeStatus', "false");
      this.switchTarget.setAttribute("name", "sun-fill")
    } else {
      this.htmlElement.classList.add("sl-theme-dark")
      localStorage.setItem('darkModeStatus', "true");
      this.switchTarget.setAttribute("name", "sun")
    }
  }

  get htmlElement() {
    return document.querySelector("html") as HTMLElement
  }
}

