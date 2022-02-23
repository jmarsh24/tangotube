import { Controller } from "@hotwired/stimulus"
import { FetchRequest } from "@rails/request.js"
const debounce = require('lodash.debounce');

export default class extends Controller {
  static get targets() { return [ "input" ] }

  async submit() {
    const url = this.data.get("url");
    const request = new FetchRequest('post',
                                    `${url}?query=${this.inputTarget.value}`, {
                                    responseKind: "turbo-stream" })
    await request.perform()
  }

  initialize() {
    this.submit = debounce(this.submit, 200).bind(this)
  }
}
