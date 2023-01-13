import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  toggle(): void {
    this.element.classList.toggle('active');
  }
}
