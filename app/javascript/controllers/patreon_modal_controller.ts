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
    const initialTimestamp = localStorage.getItem('initialTimestamp');
    if (!initialTimestamp) {
      this.resetTimestamp();
      return 0;
    } else {
      return (Date.now() - Number(initialTimestamp)) / 60000;
    }
  }

  isModalOpen(): boolean {
    return document.querySelector('.modal--open') !== null;
  }

  resetTimestamp(): void {
    localStorage.setItem('initialTimestamp', String(Date.now()));
  }
}
