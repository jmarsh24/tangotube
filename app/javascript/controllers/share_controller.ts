import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static values = { url: String };
  declare readonly urlValue: string;

  connect(): void {
    if (!navigator.share) {
      this.element.classList.add('hidden');
    }
  }

  share(): void {
    if (navigator.share) {
      navigator.share({ url: this.urlValue });
    } else {
      console.log('Fallback share behavior');
    }
  }
}
