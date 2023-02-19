import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  // @ts-ignore
  element: HTMLFormElement;

  clear(event: InputEvent): void {
    Array.from(event.target.form.elements).forEach((element) => {
      element.disabled = true;
    });
    (event.target as HTMLInputElement).form.requestSubmit();
  }

  save(): void {
    Array.from(event.target.form.elements).forEach((element) => {
      if (element.value == '') {
        element.disabled = true;
      }
    });
    (event.target as HTMLInputElement).form.requestSubmit();
  }
}
