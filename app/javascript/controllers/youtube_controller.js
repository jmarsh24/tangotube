import { Controller } from 'stimulus'
import YouTubePlayer from 'youtube-player'

export default class extends Controller {
  static values = {
    videoId: String,
    startSeconds: Number,
    endSeconds: Number
  }
  static targets = ['frame']

  initialize () {
    this.startSeconds = this.startSecondsValue
    this.endSeconds = this.endSecondsValue
    this.element['youtube'] = this
  }

  connect () {
    var playerConfig = {
      videoId: this.videoIdValue,
      playerVars: {
        autoplay: 0, // Auto-play the video on load
        controls: 1, // Show pause/play buttons in player
        modestbranding: 1, // Hide the Youtube Logo
        fs: 1, // Hide the full screen button
        cc_load_policy: 0, // Hide closed captions
        iv_load_policy: 3, // Hide the Video Annotations
        start: this.startSeconds,
        end: this.endSeconds
      }
    }

    const player = YouTubePlayer(this.frameTarget, playerConfig)

    player.on('ready', e => {
      this.element.setAttribute('data-duration', e.target.getDuration())
      this.youtube = e.target
      this.element.setAttribute('data-time', this.time)
      this.element.setAttribute('data-state', -1)
    })

    player.on('stateChange', e => {
      if (e.data === YT.PlayerState.ENDED) {
        player.loadVideoById({
          videoId: this.videoIdValue,
          startSeconds: this.startSeconds,
          endSeconds: this.endSeconds
        })
      }
    })
  }

  // disconnect () {
  //   document.removeEventListener('turbolinks:before-cache', this.player.destroy)
  //   document.removeEventListener('turbo:before-cache', this.player.destroy)
  // }

  startTimer () {
    this.timer = setInterval(() => {
      this.element.setAttribute('data-time', this.time)
      this.element.dispatchEvent(
        new CustomEvent('youtube', {
          bubbles: false,
          cancelable: false,
          detail: { time: this.time }
        })
      )
    }, 1000)
  }

  play = () => this.player.playVideo()
  pause = () => this.player.pauseVideo()
  stop = () => this.player.stopVideo()
  seek = seconds => this.player.seekTo(seconds)
  playbackSpeed = playbackSpeed => this.player.setPlaybackRate(.25)

  get player () {
    return this.youtube
  }
  get time () {
    return Math.round(this.player.getCurrentTime())
  }
  get duration () {
    return this.player.getDuration()
  }
  get state () {
    return this.element.getAttribute('data-state')
  }
  get loaded () {
    return this.player.getVideoLoadedFraction()
  }
}
