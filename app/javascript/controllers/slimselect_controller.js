import { Controller } from 'stimulus'
import SlimSelect from 'slim-select'
import 'slim-select/dist/slimselect.min.css'

export default class extends Controller {
static values = { placeholder: String }

  connect () {
    const closeOnSelect = false
    const allowDeselect = true
    const showContent = 'down'
    const searchFocus = false
    const searchPlaceholder = this.placeholderValue


    this.slimselect = new SlimSelect({
      select: this.element,
      searchPlaceholder,
      closeOnSelect,
      allowDeselect,
      showContent,
      searchFocus,
      beforeClose: function (e) {
        e.preventDefault()
      },
    })
    this.slimselect.open()
  }

  disconnect () {
    this.slimselect.destroy()
  }
}
