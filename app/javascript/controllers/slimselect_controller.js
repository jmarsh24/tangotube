import { Controller } from 'stimulus'
import SlimSelect from 'slim-select'
import 'slim-select/dist/slimselect.min.css'

export default class extends Controller {
  connect () {
    // const limit = this.data.get('limit')
    // const placeholder = this.data.get('placeholder')
    // const searchText = this.data.get('no-results')
    // const closeOnSelect = this.single
    // const allowDeselect = !this.element.required

    this.select = new SlimSelect({
      select: this.element,
      searchingText: 'Searching...', // Optional - Will show during ajax request
      ajax: function (search, callback) {
        // Check search value. If you dont like it callback(false) or callback('Message String')
        if (search.length < 3) {
          callback('Need 3 characters')
          return
        }

        // Perform your own ajax request here
        fetch('/leaders')
        .then(function (response) {
          return response.json()
        })
        .then(function (json) {
          let data = []
          for (let i = 0; i < json.length; i++) {
            data.push({text: json[i].name})
          }

          // Upon successful fetch send data to callback function.
          // Be sure to send data back in the proper format.
          // Refer to the method setData for examples of proper format.
          callback(data)
        })
        .catch(function(error) {
          // If any erros happened send false back through the callback
          callback(false)
        })
      }
    })
  }
}
