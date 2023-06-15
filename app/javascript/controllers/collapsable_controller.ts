import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="collapsable"
export default class extends Controller {
  toggle(): void {
    this.element.classList.toggle('open');
  }
}
