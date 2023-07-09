import { Controller } from '@hotwired/stimulus';
import debounce from 'lodash.debounce';

export default class extends Controller {
  connect() {
    this.submit = debounce(this.submit, 300);
  }

  submit() {
    const event = new Event('submit', { bubbles: true });
    this.element.dispatchEvent(event);
  }
}
