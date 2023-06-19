import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="filter-chip"
export default class extends Controller {
  static values = { url: String };
  urlValue!: string;

  close() {
    const url = this.urlValue;
    window.location.href = url;
  }
}
