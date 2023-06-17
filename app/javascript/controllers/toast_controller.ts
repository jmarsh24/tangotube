import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="toast"
export default class extends Controller {
  static targets = ['toast', 'content'];
  contentTarget!: HTMLElement;
  toastTarget!: HTMLElement;

  show() {
    this.toastTarget.classList.remove('hidden');
    this.toastTarget.classList.remove('slide-out');
    this.contentTarget.innerText = 'Link copied to clipboard!';
    setTimeout(() => this.hide(), 3000);
  }

  hide() {
    this.toastTarget.classList.add('slide-out');
    setTimeout(() => {
      this.toastTarget.classList.add('hidden');
      this.contentTarget.innerText = '';
    }, 1000);
  }
}
