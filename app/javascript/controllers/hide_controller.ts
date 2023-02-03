import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['target'];
  declare targetTarget: HTMLDivElement;

  toggle(event: Event): void {
    event.preventDefault();
    this.targetTarget.classList.toggle('hidden');
  }
}
