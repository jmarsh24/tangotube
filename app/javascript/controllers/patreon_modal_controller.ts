import { Controller } from '@hotwired/stimulus';
import { ui } from '@nerdgeschoss/shimmer';

export default class extends Controller {
  connect(): void {
    this.checkModal();
  }

  checkModal(): void {
    const initialTimestamp: string | null =
      localStorage.getItem('initialTimestamp');
    if (!initialTimestamp) {
      localStorage.setItem('initialTimestamp', String(Date.now()));
    } else {
      const elapsedMinutes: number =
        (Date.now() - Number(initialTimestamp)) / 60000;
      if (elapsedMinutes > 30) {
        ui.modal.open({ url: '/support_us' });
      }
    }

    setTimeout(() => this.checkModal(), 60000);
  }
}
