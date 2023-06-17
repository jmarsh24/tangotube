import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  connect(): void {
    this.element.classList.toggle('share-supported', 'canShare' in navigator);
  }
}
