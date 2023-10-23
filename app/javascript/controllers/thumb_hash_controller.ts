import { Controller } from '@hotwired/stimulus';
import { thumbHashToDataURL } from 'thumbhash';

export default class extends Controller {
  static values = { previewHash: String };
  previewHashValue!: string;

  connect() {
    const byteArray = this.hexToBytes(this.previewHashValue);
    const dataURL = thumbHashToDataURL(byteArray);

    (this.element as HTMLElement).style.backgroundImage = `url(${dataURL})`;
    this.element.classList.add('fade-in');
  }

  hexToBytes(hex: string): Array<number> {
    const bytes = [];
    for (let i = 0; i < hex.length; i += 2) {
      bytes.push(parseInt(hex.substr(i, 2), 16));
    }
    return bytes;
  }
}
