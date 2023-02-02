import { Controller } from '@hotwired/stimulus';
import { FetchRequest } from '@rails/request.js';
import { debounce } from 'lodash';
export default class extends Controller {
  inputTarget!: HTMLInputElement;
  event!: Event;

  static get targets() {
    return ['input'];
  }

  initialize() {
    this.submit = debounce(this.submit, 200).bind(this);
  }

  async submit() {
    const url = this.data.get('url');
    const request = new FetchRequest(
      'post',
      `${url}?query=${this.inputTarget.value}`,
      {
        responseKind: 'turbo-stream',
      }
    );
    await request.perform();
  }

  hideValidationMessage(event) {
    event.stopPropagation();
    event.preventDefault();
  }
}
