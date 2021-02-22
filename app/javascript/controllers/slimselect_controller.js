import { Controller } from 'stimulus'
import SlimSelect from 'slim-select'
import 'slim-select/dist/slimselect.min.css'

export default class extends Controller {
   static targets = ['field']

  connect() {
    const url = this.fieldTarget.dataset.slimselectUrl

    new SlimSelect({
      select: this.element,
      searchHighlight: true,
      closeOnSelect: false,
      searchingText: 'Searching...', // Optional - Will show during ajax request
      ajax: function (search, callback) {
        // Check search value. If you dont like it callback(false) or callback('Message String')
        if (search.length < 3) {
          callback('Need 3 characters')
          return
        }

        // Perform your own ajax request here
        fetch(url + '?q=' + search)
        .then(function (response) {
          return response.json()
        })
        .then(function (json) {
          let data = []
          for (let i = 0; i < json.length; i++) {
            data.push({ value: json[i][1], text: json[i][0] })
          }

          // Upon successful fetch send data to callback function.
          // Be sure to send data back in the proper format.
          // Refer to the method setData for examples of proper format.
          console.log(data)
          callback(data)
        })
        .catch(function(error) {
          // If any erros happened send false back through the callback
          callback(false)
        })
      }
    })
  }

  open() {
    console.log('slimselect open fired')
    var select = document.querySelector('select#genre')
    select.slim.open()
    var select = document.querySelector('select#leader')
    select.slim.open()
    var select = document.querySelector('select#follower')
    select.slim.open()
    var select = document.querySelector('select#orchestra')
    select.slim.open()
  }
}
