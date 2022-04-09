import { Controller } from "@hotwired/stimulus";
import Combobox from "@github/combobox-nav";

export default class extends Controller {
  static get targets() {
    return ["input", "list", "window"];
  }

  disconnect() {
    this.combobox?.destroy();
  }

  listTargetConnected() {
    this.start();
  }

  hidden() {
    if (this.listTarget.innerHTML.trim().length == 0) {
      this.windowTarget.classList.add("isHidden");
    }
    if (this.listTarget.innerHTML.trim().length > 0) {
      this.windowTarget.classList.remove("isHidden");
    }
    if (this.inputTarget.value.trim().length == 0) {
      this.windowTarget.classList.add("isHidden");
    }
    if (this.inputTarget.value.trim().length > 0) {
      this.windowTarget.classList.remove("isHidden");
    }
  }

  start() {
    this.hidden();
    this.combobox?.destroy();
    this.combobox = new Combobox(this.inputTarget, this.listTarget);
    this.combobox.start();
  }

  stop() {
    this.windowTarget.classList.add("isHidden");
    this.combobox?.stop();
  }
}
