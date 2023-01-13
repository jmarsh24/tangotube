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

  private get eventName(): string {
    return this.eventValue || 'input';
  }

  private onChange(event: InputEvent): void {
    (event.target as HTMLInputElement).form.requestSubmit();
  }
}
