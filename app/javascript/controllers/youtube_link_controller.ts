import { Controller } from '@hotwired/stimulus';

export default class YoutubeLinkController extends Controller {
  static targets = ["link"];

  openLink() {
    const youtubeAppLink = "vnd.youtube://www.youtube.com/watch?v=72y7yWvXhDo";
    const userAgent = navigator.userAgent.toLowerCase();

    if (userAgent.includes("android") && userAgent.includes("chrome")) {
      // Open in the YouTube app on Android Chrome
      window.location.href = youtubeAppLink;
    } else if (userAgent.includes("iphone") || userAgent.includes("ipad")) {
      // Open in the YouTube app on iOS Safari
      window.location.href = youtubeAppLink;
    } else {
      // Open in a browser for desktop browsers or if YouTube app is not installed
      const link = this.linkTarget as HTMLAnchorElement;
      link.click();
    }
  }
}
