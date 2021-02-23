import { Controller } from 'stimulus'
import SlimSelect from 'slim-select'
import 'slim-select/dist/slimselect.min.css'

export default class extends Controller {
   static targets = ['field']

  connect() {
    const url = this.fieldTarget.dataset.slimselectUrl

    // new SlimSelect({
    //   select: this.element,
    //   searchHighlight: true,
    //   closeOnSelect: false,
    //   showContent: 'down',
    //   searchingText: 'Searching...', // Optional - Will show during ajax request
    //   ajax: function (search, callback) {
    //     // Check search value. If you dont like it callback(false) or callback('Message String')
    //     if (search.length < 3) {
    //       callback('Need 3 characters')
    //       return
    //     }

    //     // Perform your own ajax request here
    //     fetch(url + '?q=' + search)
    //     .then(function (response) {
    //       return response.json()
    //     })
    //     .then(function (json) {
    //       let data = []
    //       for (let i = 0; i < json.length; i++) {
    //         data.push({ value: json[i][1], text: json[i][0] })
    //       }

    //       // Upon successful fetch send data to callback function.
    //       // Be sure to send data back in the proper format.
    //       // Refer to the method setData for examples of proper format.
    //       console.log(data)
    //       callback(data)
    //     })
    //     .catch(function(error) {
    //       // If any erros happened send false back through the callback
    //       callback(false)
    //     })
    //   }
    // })

    const limit = this.data.get('limit')
    const placeholder = this.data.get('placeholder')
    const searchText = this.data.get('no-results')
    const closeOnSelect = false
    const allowDeselect = !this.element.required
    const showContent = 'down'
    const searchFocus = false

    var select = new SlimSelect({
        select: this.element,
        beforeClose: function (event) { event.preventDefault().select.open()},
        closeOnSelect,
        allowDeselect,
        limit,
        placeholder,
        searchText,
        showContent,
        searchFocus
      })
      select.open()
  }

  open() {
    console.log('slimselect open fired')
    var select = document.querySelectorAll('select')
    select.forEach(select => select.slim.open())
  }
}
