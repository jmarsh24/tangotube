import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
static targets = ["filterButton",
                  "filter",
                  "toggleable",
                  "sideNavContainer",
                  "mainSectionContainer",
                  "disableable",
                  "lyricsEs",
                  "lyricsEn",
                  "recommendedSongVideos",
                  "recommendedSongVideosDownButton",
                  "recommendedSongVideosUpButton",
                  "recommendedEventVideos",
                  "recommendedEventVideosDownButton",
                  "recommendedEventVideosUpButton",
                  "recommendedChannelVideos",
                  "recommendedChannelVideosDownButton",
                  "recommendedChannelVideosUpButton",
                  "recommendedPerformanceVideos",
                  "recommendedPerformanceVideosDownButton",
                  "recommendedPerformanceVideosUpButton"];

  toggle() {
    this.toggleableTarget.classList.toggle("isHidden");
  }

  toggleRecommendedSongVideos() {
    this.recommendedSongVideosTarget.classList.toggle("recommended-videos-card--active")
    this.recommendedSongVideosDownButtonTarget.classList.toggle("isHidden");
    this.recommendedSongVideosUpButtonTarget.classList.toggle("isHidden");
  }

  toggleRecommendedEventVideos() {
    this.recommendedEventVideosTarget.classList.toggle("recommended-videos-card--active")
    this.recommendedEventVideosDownButtonTarget.classList.toggle("isHidden");
    this.recommendedEventVideosUpButtonTarget.classList.toggle("isHidden");
  }

  toggleRecommendedChannelVideos() {
    this.recommendedChannelVideosTarget.classList.toggle("recommended-videos-card--active")
    this.recommendedChannelVideosDownButtonTarget.classList.toggle("isHidden");
    this.recommendedChannelVideosUpButtonTarget.classList.toggle("isHidden");
  }

  toggleRecommendedPerformanceVideos() {
    this.recommendedPerformanceVideosTarget.classList.toggle("recommended-videos-card--active")
    this.recommendedPerformanceVideosDownButtonTarget.classList.toggle("isHidden");
    this.recommendedPerformanceVideosUpButtonTarget.classList.toggle("isHidden");
  }

  toggleLyricsSpanish() {
    this.lyricsEnTarget.classList.add("isHidden");
    this.lyricsEsTarget.classList.remove("isHidden");
  }

  toggleLyricsEnglish() {
    this.lyricsEnTarget.classList.remove("isHidden");
    this.lyricsEsTarget.classList.add("isHidden");
  }

  toggleFilter() {
    this.filterTarget.classList.toggle("isHidden");
    this.filterButtonTarget.classList.toggle("isActive");
  }

  navShowHide() {
      this.sideNavContainerTarget.classList.toggle('isHidden')
      this.mainSectionContainerTarget.classList.toggle('leftPadding')
  }

  disableFilters() {
    const ssfilterListItems = document.getElementsByClassName("ss-list")
    const ssfilterContainer = document.getElementsByClassName('ss-content ss-open')

    Array.from(ssfilterListItems).forEach(element => element.classList.toggle('disabled'))
    Array.from(ssfilterContainer).forEach(element => element.classList.toggle('disabled'))
  }
}
