import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="dark"
export default class extends Controller {
  iconTarget!: HTMLElement;

  static targets = ['icon'];

  connect() {
    if (this.darkMode) {
      document.body.classList.remove('light');
      this.iconTarget.classList.remove('icon--sun-max-fill');
      this.iconTarget.classList.add('icon--sun-max');
    } else {
      document.body.classList.add('light');
      this.iconTarget.classList.remove('icon--sun-max');
      this.iconTarget.classList.add('icon--sun-max-fill');
    }
  }

  dark() {
    this.darkMode = false;
    document.body.classList.remove('light');
    this.iconTarget.classList.remove('icon--sun-max-fill');
    this.iconTarget.classList.add('icon--sun-max');
  }

  light() {
    this.darkMode = true;
    document.body.classList.add('light');
    this.iconTarget.classList.remove('icon--sun-max');
    this.iconTarget.classList.add('icon--sun-max-fill');
  }

  auto() {
    localStorage.removeItem('lightModeStatus');
  }

  get darkMode(): boolean {
    return localStorage.getItem('lightModeStatus') !== 'true';
  }

  set darkMode(value: boolean) {
    localStorage.setItem('lightModeStatus', value ? 'false' : 'true');
  }
}
