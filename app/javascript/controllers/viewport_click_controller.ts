import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  #observer: IntersectionObserver;

  connect(): void {
    this.#observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((e) => {
          if (e.isIntersecting) {
            const link = e.target as HTMLLinkElement;
            link.click();
          }
        });
      },
      {
        threshold: 1.0,
      }
    );
    this.#observer.observe(this.element);
  }

  disconnect(): void {
    this.#observer.disconnect();
  }
}
