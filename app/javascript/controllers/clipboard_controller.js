import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ["button", "startTime", "endTime", "playbackSpeed", "source"]
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
    this.playbackSpeedValue = this.playbackSpeedTarget.value
    this.startTimeValue = this.parseTime(this.startTimeTarget.value)
    this.endTimeValue = this.parseTime(this.endTimeTarget.value)
    this.urlValueUpdate()
  }

  copy () {
    navigator.clipboard.writeText(this.urlValue)
    this.copied()
  }

  copied () {
    this.buttonTarget.innerText = this.data.get('successContent')

    setTimeout(() => {
      this.buttonTarget.innerHTML = this.originalText
    }, this.successDurationValue)
  }

  parseTime(time) {
    var timeArray = time.toString().split(':')
    var timeInSeconds = 0
    if (timeArray.length == 2) {
      timeInSeconds = (+timeArray[0]) * 60 + (+timeArray[1])
    }
    if (timeArray.length == 1) {
      timeInSeconds = timeArray[0]
    }
    return parseInt(timeInSeconds)
  }

  urlValueUpdate() {
    this.urlValue = `${this.data.get('rootUrl')}watch?v=${this.data.get('videoId')}`

    if (this.startTimeValue > 0 & this.endTimeValue > 0 & this.playbackSpeedValue != 1 & this.startTimeValue < this.endTimeValue) {
      this.urlValue = `${this.urlValue}&start=${this.startTimeValue}&end=${this.endTimeValue}&speed=${this.playbackSpeedValue}`
    }
    else if (this.startTimeValue > 0 & this.endTimeValue > 0 & this.playbackSpeedValue == 1 & this.startTimeValue < this.endTimeValue) {
      this.urlValue = `${this.urlValue}&start=${this.startTimeValue}&end=${this.endTimeValue}`
    }
    else if (this.startTimeValue > 0 & this.endTimeValue == 0 & this.playbackSpeedValue != 1) {
      this.urlValue = `${this.urlValue}&start=${this.startTimeValue}&speed=${this.playbackSpeedValue}`
    }
    else if (this.startTimeValue == 0 & this.endTimeValue == 0 & this.playbackSpeedValue != 1) {
      this.urlValue = `${this.urlValue}&speed=${this.playbackSpeedValue}`
    }
    else if (this.startTimeValue > 0) {
      this.urlValue = `${this.urlValue}&start=${this.startTimeValue}`
    }

    this.sourceTarget.value = this.urlValue
  }

  changeValue() {
    this.playbackSpeedValue = this.playbackSpeedTarget.value
    this.startTimeValue = this.parseTime(this.startTimeTarget.value)
    this.endTimeValue = this.parseTime(this.endTimeTarget.value)
    this.urlValueUpdate()
    this.sourceTarget.value = this.urlValue
  }
}
