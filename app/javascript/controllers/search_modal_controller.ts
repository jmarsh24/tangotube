import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="search-modal"
export default class extends Controller {
  static targets = ['modal'];
  modalTarget!: HTMLElement;

  show(): void {
    document.body.classList.add('search-window--open');
    this.modalTarget.classList.add('search-window--open');
  }

  close(): void {
    document.body.classList.remove('search-window--open');
    this.modalTarget.classList.remove('search-window--open');
  }
}
