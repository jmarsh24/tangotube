import { Controller } from '@hotwired/stimulus';

export default class SupportedController extends Controller {
  connect(): void {
    this.toggleShareSupport();
    this.toggleYoutubeAppSupport();
    this.toggleSpotifyAppSupport();
  }

  toggleShareSupport(): void {
    const isShareSupported = 'canShare' in navigator;
    this.element.classList.toggle('share-supported', isShareSupported);
  }

  toggleYoutubeAppSupport(): void {
    const isYoutubeAppSupported = this.isYoutubeAppSupported();
    this.element.classList.toggle(
      'youtube-app-supported',
      isYoutubeAppSupported
    );
  }

  toggleSpotifyAppSupport(): void {
    const isSpotifyAppSupported = this.isSpotifyAppSupported();
    this.element.classList.toggle(
      'spotify-app-supported',
      isSpotifyAppSupported
    );
  }

  isYoutubeAppSupported(): boolean {
    const userAgent = navigator.userAgent.toLowerCase();
    return (
      (userAgent.includes('android') && userAgent.includes('chrome')) ||
      userAgent.includes('iphone') ||
      userAgent.includes('ipad')
    );
  }

  isSpotifyAppSupported(): boolean {
    const userAgent = navigator.userAgent.toLowerCase();
    return userAgent.includes('spotify');
  }
}
