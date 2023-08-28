import { Controller } from '@hotwired/stimulus';
import debounce from 'lodash.debounce';

export default class extends Controller {
  static targets = ['modal', 'mobileInput', 'desktopInput', 'results'];
  modalTarget!: HTMLElement;
  mobileInputTarget!: HTMLInputElement;
  desktopInputTarget!: HTMLInputElement;
  resultsTarget!: HTMLElement;

  debouncedSubmit!: (query: string) => void; // Declare debouncedSubmit

  connect(): void {
    this.debouncedSubmit = debounce(this.submit, 300); // No need for bind, since arrow functions are used.
  }

  show(): void {
    document.body.classList.add('search-window--open');
    this.modalTarget.classList.add('search-window--open');
  }

  close(): void {
    document.body.classList.remove('search-window--open');
    this.modalTarget.classList.remove('search-window--open');
  }

  search(event: Event): void {
    const updatedValue = (event.target as HTMLInputElement).value;

    this.desktopInputTarget.value = updatedValue;
    this.mobileInputTarget.value = updatedValue;

    this.debouncedSubmit(updatedValue);
  }

  private submit = (query: string): void => {
    const newSrc = `/search?query=${encodeURIComponent(query)}`;
    this.resultsTarget.setAttribute('src', newSrc);
  };
}
