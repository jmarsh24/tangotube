import { Controller } from '@hotwired/stimulus';
import { thumbHashToDataURL } from 'thumbhash';

// thumb_hash_controller.ts
export default class extends Controller {
  static values = { previewHash: String };
  previewHashValue!: string;

  connect() {
    const byteArray = this.hexToBytes(this.previewHashValue);
    (
      this.element as HTMLElement
    ).style.backgroundImage = `url(${thumbHashToDataURL(byteArray)})`;
  }

  hexToBytes(hex: string): Array<number> {
    const bytes = [];
    for (let i = 0; i < hex.length; i += 2) {
      bytes.push(parseInt(hex.substr(i, 2), 16));
    }
    return bytes;
  }
}
