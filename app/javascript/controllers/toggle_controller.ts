import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  on(): void {
    this.element.classList.add('active');
  }
  off(): void {
    this.element.classList.remove('active');
  }
}
