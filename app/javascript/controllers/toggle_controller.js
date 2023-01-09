import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = [
    'filterButton',
    'filter',
    'sorting',
    'sortingButton',
    'toggleable',
    'mainSectionContainer',
    'disableable',
    'lyricsEs',
    'lyricsEn',
    'recommendedSongVideos',
    'recommendedSongVideosDownButton',
    'recommendedSongVideosUpButton',
    'recommendedEventVideos',
    'recommendedEventVideosDownButton',
    'recommendedEventVideosUpButton',
    'recommendedSameDancersVideos',
    'recommendedSameDancersVideosDownButton',
    'recommendedSameDancersVideosUpButton',
    'recommendedChannelVideos',
    'recommendedChannelVideosDownButton',
    'recommendedChannelVideosUpButton',
    'recommendedPerformanceVideos',
    'recommendedPerformanceVideosDownButton',
    'recommendedPerformanceVideosUpButton',
  ];

  toggle() {
    this.toggleableTarget.classList.toggle('isHidden');
  }

  toggleRecommendedSongVideos() {
    this.recommendedSongVideosTarget.classList.toggle(
      'recommended-videos-card--active'
    );
    this.recommendedSongVideosDownButtonTarget.classList.toggle('isHidden');
    this.recommendedSongVideosUpButtonTarget.classList.toggle('isHidden');
  }

  toggleRecommendedSameDancersVideos() {
    this.recommendedSameDancersVideosTarget.classList.toggle(
      'recommended-videos-card--active'
    );
    this.recommendedSameDancersVideosDownButtonTarget.classList.toggle(
      'isHidden'
    );
    this.recommendedSameDancersVideosUpButtonTarget.classList.toggle(
      'isHidden'
    );
  }

  toggleRecommendedEventVideos() {
    this.recommendedEventVideosTarget.classList.toggle(
      'recommended-videos-card--active'
    );
    this.recommendedEventVideosDownButtonTarget.classList.toggle('isHidden');
    this.recommendedEventVideosUpButtonTarget.classList.toggle('isHidden');
  }

  toggleRecommendedChannelVideos() {
    this.recommendedChannelVideosTarget.classList.toggle(
      'recommended-videos-card--active'
    );
    this.recommendedChannelVideosDownButtonTarget.classList.toggle('isHidden');
    this.recommendedChannelVideosUpButtonTarget.classList.toggle('isHidden');
  }

  toggleRecommendedPerformanceVideos() {
    this.recommendedPerformanceVideosTarget.classList.toggle(
      'recommended-videos-card--active'
    );
    this.recommendedPerformanceVideosDownButtonTarget.classList.toggle(
      'isHidden'
    );
    this.recommendedPerformanceVideosUpButtonTarget.classList.toggle(
      'isHidden'
    );
  }

  toggleLyricsSpanish() {
    this.lyricsEnTarget.classList.add('isHidden');
    this.lyricsEsTarget.classList.remove('isHidden');
  }

  toggleLyricsEnglish() {
    this.lyricsEnTarget.classList.remove('isHidden');
    this.lyricsEsTarget.classList.add('isHidden');
  }

  toggleFilter() {
    this.filterTarget.classList.toggle('isHidden');
    this.sortingTarget.classList.add('isHidden');
    this.filterButtonTarget.classList.toggle('isActive');
  }

  toggleSorting() {
    this.sortingTarget.classList.toggle('isHidden');
    this.filterTarget.classList.add('isHidden');
    this.sideNavContainerTarget.classList.add('isHidden');
    this.sortingButtonTarget.classList.toggle('isActive');
  }

  navShowHide() {
    this.sideNavContainerTarget.classList.toggle('isHidden');
    this.filterTarget.classList.toggle('isHidden');
    this.filterTarget.classList.add('isHidden');
    this.sortingTarget.classList.add('isHidden');
  }

  disableFilters() {
    const ssfilterListItems = document.getElementsByClassName('ss-list');
    const ssfilterContainer =
      document.getElementsByClassName('ss-content ss-open');

    Array.from(ssfilterListItems).forEach((element) =>
      element.classList.toggle('disabled')
    );
    Array.from(ssfilterContainer).forEach((element) =>
      element.classList.toggle('disabled')
    );
  }
}
