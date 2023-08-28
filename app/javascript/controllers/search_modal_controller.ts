import { Controller } from '@hotwired/stimulus';
import debounce from 'lodash.debounce';

// Connects to data-controller="search-modal"
export default class extends Controller {
  static targets = ['modal', 'input', 'results'];
  modalTarget!: HTMLElement;
  inputTarget!: HTMLInputElement;
  resultsTarget!: HTMLElement;

  connect(): void {
    this.submit = debounce(this.submit, 300);
  }

  show(): void {
    document.body.classList.add('search-window--open');
    this.modalTarget.classList.add('search-window--open');
  }

  close(): void {
    document.body.classList.remove('search-window--open');
    this.modalTarget.classList.remove('search-window--open');
  }

  submit(): void {
    const query = this.inputTarget.value;
    const newSrc = `/search?query=${encodeURIComponent(query)}`;
    this.resultsTarget.setAttribute('src', newSrc);
  }
}
