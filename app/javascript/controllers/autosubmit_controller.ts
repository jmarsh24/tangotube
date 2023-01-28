import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static values = { event: String };

  declare readonly eventValue?: string;

  connect(): void {
    this.element.addEventListener(this.eventName, this.onChange);
  }

  disconnect(): void {
    this.element.removeEventListener(this.eventName, this.onChange);
  }

  clear(event: InputEvent): void {
    Array.from(event.target.form.elements).forEach((element) => {
      element.disabled = true;
    });
    (event.target as HTMLInputElement).form.requestSubmit();
  }

  private get eventName(): string {
    return this.eventValue || 'input';
  }

  private onChange(event: InputEvent): void {
    Array.from(event.target.form.elements).forEach((element) => {
      if (element.value == '') {
        element.disabled = true;
      }
    });
    (event.target as HTMLInputElement).form.requestSubmit();
  }
}
