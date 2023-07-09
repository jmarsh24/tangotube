import { ui } from '@nerdgeschoss/shimmer';

export function setupModalClose() {
  document.addEventListener('click', (event: Event) => {
    const clickedElement = event.target as HTMLElement;
    const modal = clickedElement.closest('.modal__content');

    if (!modal) {
      ui.modal.close();
    }
  });
}
