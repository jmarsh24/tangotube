import { Controller } from 'stimulus'
import SlimSelect from 'slim-select'
import 'slim-select/dist/slimselect.min.css'

export default class extends Controller {
  connect () {
    const limit = this.data.get('limit')
    const placeholder = this.data.get('placeholder')
    const searchText = this.data.get('no-results')
    const closeOnSelect = false
    const allowDeselect = true
    const showContent = 'down'
    const searchFocus = false

    this.slimselect = new SlimSelect({
      select: this.element,
      beforeClose: function (e) {
        e.preventDefault()
      },
      closeOnSelect,
      allowDeselect,
      limit,
      placeholder,
      searchText,
      showContent,
      searchFocus
    })
    this.slimselect.open()
  }

  disconnect () {
    this.slimselect.destroy()
  }
}
