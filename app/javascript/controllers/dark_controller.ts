import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="dark"

type theme = 'auto' | 'dark' | 'light';
export default class extends Controller {
  connect() {
    document.body.dataset.theme = this.theme;
  }

  dark() {
    this.theme = 'dark';
    document.body.dataset.theme = 'dark';
  }

  light() {
    this.theme = 'light';
    document.body.dataset.theme = 'light';
  }

  auto() {
    this.theme = 'auto';
    delete document.body.dataset['theme'];
  }

  get theme(): theme {
    return (localStorage.getItem('theme') as theme) || 'dark';
  }

  set theme(value: theme) {
    localStorage.setItem('theme', value);
  }
}
