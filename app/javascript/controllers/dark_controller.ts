import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="dark"
export default class extends Controller {
  iconTarget!: HTMLElement;

  static targets = ['icon'];

  connect() {
    if (this.darkMode) {
      this.dark();
    } else {
      this.light();
    }

    if (
      window.matchMedia &&
      window.matchMedia('(prefers-color-scheme: dark)').matches
    ) {
      this.setDarkIcon();
    } else {
      this.setLightIcon();
    }
  }

  setLight() {
    this.darkMode = true;
    this.light();
    this.setLightIcon();
    this.light();
  }

  setDark() {
    this.darkMode = false;
    this.dark();
    this.setDarkIcon();
  }

  dark() {
    document.body.classList.remove('light');
  }

  light() {
    document.body.classList.add('light');
  }

  setDarkIcon() {
    this.iconTarget.classList.remove('icon--sun-max');
    this.iconTarget.classList.add('icon--moon-fill');
  }

  setLightIcon() {
    this.iconTarget.classList.remove('icon--moon-fill');
    this.iconTarget.classList.add('icon--sun-max');
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
