import { Controller } from 'stimulus'

export default class extends Controller {
  connect() {
    setTimeout(() => {
      this.dismiss();
    }, 10000);
  }

  dismiss() {
    this.element.remove();
  }
}
