import { Controller } from "@hotwired/stimulus";
import Dropdown from "stimulus-dropdown";

export default class extends Dropdown {
  connect() {
    super.connect();
  }

  toggle(event) {
    super.toggle();
  }

  hide(event) {
    super.hide(event);
  }
}
