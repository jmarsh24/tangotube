import { Controller } from '@hotwired/stimulus'
import YouTubePlayer from 'youtube-player'

export default class extends Controller {
  static values = {
    videoId: String,
    startSeconds: Number,
    endSeconds: Number,
    playbackSpeed: Number
  }
  static targets = ["frame", "playbackSpeed", "startTime", "endTime"]

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
        start: this.startSecondsValue,
        end: this.endSecondsValue
      }
    }

    const player = YouTubePlayer(this.frameTarget, playerConfig)

    player.on('ready', e => {
      this.element.setAttribute('data-duration', e.target.getDuration())
      this.youtube = e.target
      this.element.setAttribute('data-time', this.time)
      this.element.setAttribute('data-state', -1)
    })

    player.setPlaybackRate(this.playbackSpeedValue)

    player.on('playbackRateChange', e => {
      this.playbackSpeedTarget.value = parseFloat(this.player.getPlaybackRate()).toPrecision(2).toString()
    })

    player.on('stateChange', e => {
      if (e.data === YT.PlayerState.ENDED) {
        this.player.seekTo(this.startSecondsValue)
      }
    })
  }

  updatePlaybackSpeed () {
    this.player.setPlaybackRate(parseFloat(this.playbackSpeedTarget.value))
  }

  updateStartTime () {
    var startTimeArray = this.startTimeTarget.value.split(':')
    if (startTimeArray.length == 2) {
      var startTime = (+startTimeArray[0]) * 60 + (+startTimeArray[1])
    }
    if (startTimeArray.length == 1) {
      var startTime = startTimeArray[0]
    }
    this.startSecondsValue = startTime
    this.player.loadVideoById({
      videoId: this.videoIdValue,
      startSeconds: this.startSecondsValue,
      endSeconds: this.endSecondsValue
    })
  }

  updateEndTime () {
    var endTimeArray = this.endTimeTarget.value.split(':')
    if (endTimeArray.length == 2) {
      var endTime = (+endTimeArray[0]) * 60 + (+endTimeArray[1])
    }
    if (endTimeArray.length == 1) {
      var endTime = endTimeArray[0]
    }
    this.endSecondsValue = endTime
    this.player.loadVideoById({
      videoId: this.videoIdValue,
      startSeconds: this.startSecondsValue,
      endSeconds: this.endSecondsValue
    })
  }

  disconnect () {
    document.removeEventListener('turbo:before-cache', this.player.destroy)
  }

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
