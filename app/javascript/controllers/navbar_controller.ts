import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  menuTarget!: HTMLElement;

  static targets = ['menu'];

  toggle() {
    this.menuTarget.classList.toggle('open');
  }
}
