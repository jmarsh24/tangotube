import '@hotwired/turbo-rails';
import { start, ui } from '@nerdgeschoss/shimmer';
import { application } from '/controllers/application';
import { registerControllers } from 'stimulus-vite-helpers';
import { startErrorTracking } from '/lib/error-tracking';

// Controller files must be named *_controller.ts/js.
const controllers = import.meta.glob('../**/*_controller.{ts,js}', {
  eager: true,
});
registerControllers(application, controllers);

// Load the IFrame Player API code asynchronously.
var tag = document.createElement('script');
tag.src = 'https://www.youtube.com/player_api';
var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

startErrorTracking();
start({ application });

document.addEventListener('click', (event: Event) => {
  const clickedElement = event.target as HTMLElement;
  const modal = clickedElement.closest('.modal');
  console.log('Clicked element', clickedElement);

  // Check if the clicked element is inside a modal
  if (!modal) {
    console.log('Clicked element is not inside a modal');
    // Close the modal here
    ui.modal.close();
  }
});
