import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static values = { url: String };
  declare readonly urlValue: string;

  connect(): void {
    if (!navigator.share) {
      (this.element as HTMLDivElement).hidden = true;
    }
  }

  share(): void {
    navigator.share({ url: this.urlValue });
  }
}
