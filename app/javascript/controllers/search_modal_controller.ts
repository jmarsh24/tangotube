import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="search-modal"
export default class extends Controller {
  static targets = ['modal'];
  // static values = { searchPath: String };

  modalTarget!: HTMLElement;
  // searchPathValue!: string;

  connect(): void {
    // console.log('Search modal controller connected...');
    // console.log(this.searchPathValue);
  }

  show(): void {
    // this.modalTarget.setAttribute('src', this.searchPathValue);
    this.modalTarget.style.display = 'block';
  }

  close(): void {
    this.modalTarget.style.display = 'none';
  }
}
