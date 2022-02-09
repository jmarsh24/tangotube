import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ["button"]
  static values = { source: String }

  copy () {
    navigator.clipboard.writeText(this.sourceValue)
    this.copied()
  }

  copied () {
    var originalText = this.buttonTarget.innerHTML
    this.buttonTarget.innerText = this.data.get('successContent')

    setTimeout(() => {
      this.buttonTarget.innerHTML = originalText
    }, 2000)
  }
}
