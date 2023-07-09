import { Controller } from '@hotwired/stimulus';

// Connects to data-controller="clipboard"
export default class extends Controller {
  static targets = ['source'];

  copy() {
    this.sourceTarget.select();
    navigator.clipboard.writeText(this.sourceTarget.value);
  }

  // showCopyNotification() {
  //   // Replace this with your preferred notification library or implementation
  //   // Here's an example using a basic toast notification with Bulma CSS classes
  //   const notification = document.createElement('div');
  //   notification.classList.add('notification', 'is-success');
  //   notification.textContent = 'Link copied to clipboard!';
  //   document.body.appendChild(notification);

  //   // Remove the notification after a delay (e.g., 3 seconds)
  //   setTimeout(() => {
  //     notification.remove();
  //   }, 3000);
  // }
}
