import { Controller } from 'stimulus'
import Plyr from 'plyr'

export default class extends Controller {
  static values = {
    code: String,
    width: Number,
    height: Number
  }
  static targets = ['frame']

  initialize () {
    this.width = this.widthValue || 640
    this.height = this.heightValue || 480
    this.element['youtube'] = this
  }

  connect () {
    console.log('running')
    // if (!this.hasCodeValue) return
    // debugger
    // document.addEventListener('turbo:before-cache', this.player.destroy)
    const player = new Plyr(this.frameTarget);
    // player.on('ready', e => {
    //   this.element.setAttribute('data-duration', e.target.getDuration())
    //   this.youtube = e.target
    //   this.element.setAttribute('data-time', this.time)
    //   this.element.setAttribute('data-state', -1)
    // })
    // player.on('stateChange', e => {
    //   this.element.setAttribute('data-state', e.data)
    //   this.element.setAttribute('data-time', this.time)
    //   e.data === 1 ? this.startTimer() : clearInterval(this.timer)
    // })
  }

  disconnect () {
    document.removeEventListener('turbolinks:before-cache', this.player.destroy)
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
