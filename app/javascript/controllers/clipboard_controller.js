import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ["button", "startTime", "endTime"]
  static values = { source: String,
                    originalText: String,
                    successDurationValue: Number,
                    startTime: Number,
                    endTime: Number,
                    url: String,
                    rootUrl: String}

  initialize() {
    this.successDurationValue = 2000
  }

  connect() {
    this.originalText = this.buttonTarget.innerHTML
  }

  copy () {
    this.urlValue = `${this.data.get('rootUrl')}watch?v=${this.data.get('videoId')}`

    if (this.startTimeValue > 0 & this.endTimeValue > 0 ){
      this.urlValue = `${this.urlValue}&start=${this.startTimeValue}&end=${this.endTimeValue}`
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
    if (this.startTimeTarget.value > 0 || this.endTimeTarget.value > 0) {
      this.startTimeValue = this.startTimeTarget.value
      this.endTimeValue = this.endTimeTarget.value
    }
  }
}
