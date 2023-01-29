import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="dark-mode"
export default class extends Controller {
  connect() {
    const darkModeValue = localStorage.getItem('darkModeStatus');
    const darkModeStatus = JSON.parse(darkModeValue);

    if (darkModeStatus) {
      this.htmlElement.classList.add('dark-mode');
    }

    if (this.htmlElement.classList.contains('dark-mode')) {
      this.element.setAttribute('name', 'sun');
    }
  }

  toggle() {
    if (this.htmlElement.classList.contains('dark-mode')) {
      this.htmlElement.classList.remove('dark-mode');
      localStorage.setItem('darkModeStatus', 'false');
      this.element.classList.remove('icon--sun-max');
      this.element.classList.add('icon--sun-max-fill');
      // this.element.setAttribute('name', 'sun-fill');
    } else {
      this.htmlElement.classList.add('dark-mode');
      localStorage.setItem('darkModeStatus', 'true');
      // this.element.setAttribute('name', 'sun');
      this.element.classList.remove('icon--sun-max-fill');
      this.element.classList.add('icon--sun-max');
    }
  }

  get htmlElement() {
    return document.querySelector('html') as HTMLElement;
  }
}
