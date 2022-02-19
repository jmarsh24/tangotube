import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ["button", "startTime", "endTime", "playbackSpeed"]
  static values = { source: String,
                    originalText: String,
                    successDurationValue: Number,
                    startTime: Number,
                    endTime: Number,
                    url: String,
                    rootUrl: String,
                    playbackSpeed: Number }

  initialize() {
    this.successDurationValue = 2000
  }

  connect() {
    this.originalText = this.buttonTarget.innerHTML
  }

  copy () {
    this.urlValue = `${this.data.get('rootUrl')}watch?v=${this.data.get('videoId')}`

    if (this.startTimeValue > 0 & this.endTimeValue > 0 ){
      this.urlValue = `${this.urlValue}&start=${this.startTimeValue}&end=${this.endTimeValue}&speed=${this.playbackSpeedValue}`
    }

    if (this.startTimeValue > 0 & isNaN(this.endTimeValue) ){
      this.urlValue = `${this.urlValue}&start=${this.startTimeValue}`
    }

    navigator.clipboard.writeText(this.urlValue)
    this.copied()
  }

  copied () {
    this.buttonTarget.innerText = this.data.get('successContent')

    setTimeout(() => {
      this.buttonTarget.innerHTML = this.originalText
    }, this.successDurationValue)
  }

  changeValue() {

    var startTimeArray = this.startTimeTarget.value.split(':')
    var endTimeArray = this.endTimeTarget.value.split(':')
    if (startTimeArray.length == 2) {
      this.startTimeValue = (+startTimeArray[0]) * 60 + (+startTimeArray[1])
    }
    if (startTimeArray.length == 1) {
      this.startTimeValue = startTimeArray[0]
    }
    if (endTimeArray.length == 2) {
      this.endTimeValue = (+endTimeArray[0]) * 60 + (+endTimeArray[1])
    }
    if (endTimeArray.length == 1) {
      this.endTimeValue = endTimeArray[0]
    }
    this.playbackSpeedValue = this.playbackSpeedTarget.value
  }
}
