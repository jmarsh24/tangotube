import { Controller } from '@hotwired/stimulus';
import Combobox from '@github/combobox-nav';
import { useClickOutside } from 'stimulus-use';

export default class extends Controller {
  inputTarget!: HTMLInputElement;
  listTarget!: HTMLUListElement;
  windowTarget!: HTMLDivElement;

  static targets = ['input', 'list', 'window'];

  connect() {
    useClickOutside(this, { element: this.element });
  }

  disconnect() {
    this.combobox?.destroy();
  }

  listTargetConnected() {
    this.start();
  }

  hidden() {
    if (this.listTarget.innerHTML.trim().length == 0) {
      this.windowTarget.classList.add('hidden');
    }
    if (this.listTarget.innerHTML.trim().length > 0) {
      this.windowTarget.classList.remove('hidden');
    }
    if (this.inputTarget.value.trim().length == 0) {
      this.windowTarget.classList.add('hidden');
    }
    if (this.inputTarget.value.trim().length > 0) {
      this.windowTarget.classList.remove('hidden');
    }
  }

  clickOutside() {
    this.windowTarget.classList.add('hidden');
  }

  start() {
    this.hidden();
    this.combobox?.destroy();
    this.combobox = new Combobox(this.inputTarget, this.listTarget);
    this.combobox.start();
  }

  stop() {
    this.windowTarget.classList.add('hidden');
    this.combobox?.stop();
  }
}
