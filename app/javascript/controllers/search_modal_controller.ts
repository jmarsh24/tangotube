import { Controller } from '@hotwired/stimulus';
import { ui } from '@nerdgeschoss/shimmer';

// Connects to data-controller="search-modal"
export default class extends Controller {
  show() {
    ui.modal.open({ url: '/search/new' });
  }
}
