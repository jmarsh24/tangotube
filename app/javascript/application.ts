import '@hotwired/turbo-rails';
import { start } from '@nerdgeschoss/shimmer';
import { application } from '/controllers/application';
import { registerControllers } from 'stimulus-vite-helpers';
import { startErrorTracking } from '/lib/error-tracking';
import { setupModalClose } from '/lib/modal';
import { loadYouTubePlayerAPI } from '/lib/youtube';

// Controller files must be named *_controller.ts/js.
const controllers = import.meta.glob('../**/*_controller.{ts,js}', {
  eager: true,
});
registerControllers(application, controllers);

startErrorTracking();
start({ application });

setupModalClose();
loadYouTubePlayerAPI();
