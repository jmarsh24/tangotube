import { Controller } from '@hotwired/stimulus';

// image_loading_controller.ts
export default class extends Controller {
  connect() {
    if ((this.element as HTMLImageElement).complete) {
      this.loaded();
    }
  }

  loadImage(event: Event) {
    this.loaded();
  }

  loaded() {
    this.element.classList.remove('loading');
  }
}
