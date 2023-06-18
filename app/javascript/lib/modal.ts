import { ui } from '@nerdgeschoss/shimmer';

export function setupModalClose() {
  document.addEventListener('click', (event: Event) => {
    const clickedElement = event.target as HTMLElement;
    const modal = clickedElement.closest('.modal');
    console.log('Clicked element', clickedElement);

    // Check if the clicked element is inside a modal
    if (modal) {
      // Close the modal here
      ui.modal.close();
    }
  });
}
