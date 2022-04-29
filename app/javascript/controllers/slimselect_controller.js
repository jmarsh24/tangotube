import { Controller } from "@hotwired/stimulus";
import SlimSelect from "slim-select";

export default class extends Controller {
  static values = { placeholder: String };

  connect() {
    const closeOnSelect = false;
    const allowDeselect = true;
    const showContent = "down";
    const searchFocus = false;
    const searchPlaceholder = this.placeholderValue;

    this.slimselect = new SlimSelect({
      select: this.element,
      searchPlaceholder,
      placeholder: this.placeholderValue,
      closeOnSelect,
      allowDeselect,
      showContent,
      searchFocus,
    });
  }

  disconnect() {
    this.slimselect.destroy();
  }
}
