import { Controller } from '@hotwired/stimulus';
import { ui } from '@nerdgeschoss/shimmer';

export default class extends Controller {
  connect(): void {
    this.checkAndShowModal();
  }

  checkAndShowModal(): void {
    if (this.shouldShowModal()) {
      ui.modal.open({ url: '/support_us' });
      this.resetTimestamp();
    }
  }

  shouldShowModal(): boolean {
    const elapsedMinutes = this.getMinutesSinceLastTimestamp();
    return elapsedMinutes > 30 && !this.isModalOpen();
  }

  getMinutesSinceLastTimestamp(): number {
    const lastModalShownTimestamp = localStorage.getItem(
      'lastModalShownTimestamp'
    );
    if (!lastModalShownTimestamp) {
      this.resetTimestamp();
      return 0;
    } else {
      return (Date.now() - Number(lastModalShownTimestamp)) / 60000;
    }
  }

  isModalOpen(): boolean {
    return document.querySelector('.modal--open') !== null;
  }

  resetTimestamp(): void {
    localStorage.setItem('lastModalShownTimestamp', String(Date.now()));
  }
}
