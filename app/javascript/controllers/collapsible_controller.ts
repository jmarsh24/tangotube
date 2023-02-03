import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  public static targets = ['content'];
  declare contentTarget: HTMLDivElement;

  connect(): void {
    // min duration 0.2s, max duration 0.5s
    const transitionDuration = Math.max(
      0.2,
      Math.min(0.5, this.contentTarget.scrollHeight / 1000)
    );
    this.contentTarget.style.transitionDuration = `${transitionDuration}s`;
  }

  toggle(): void {
    const maxHeight = this.contentTarget.style.maxHeight;

    if (maxHeight && maxHeight !== '0px') {
      this.contentTarget.style.maxHeight = '0';
      this.element.classList.remove('active');
    } else {
      this.contentTarget.style.maxHeight = `${this.contentTarget.scrollHeight}px`;
      this.element.classList.add('active');
    }
  }
}
