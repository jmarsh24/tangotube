  import { Controller } from 'stimulus'
  import Rails from '@rails/ujs'

  export default class extends Controller {
    static targets = ['videos', 'loadmore']
    static values = { page: Number }

    connect() {
      console.log('loadmore controller on!')
    }

    loadMore () {
      this.pageValue++

      const url = `${window.location.href}/?page=${this.pageValue}`

      Rails.ajax({
        type: 'GET',
        url: url,
        dataType: 'html',
        success: data => {
          this.videosTarget.insertAdjacentHTML('beforeend', data.getElementById('videos').innerHTML)
          document.getElementById('load-more-container').innerHTML = data.getElementById('load-more-container').innerHTML
        }
      })
    }
  }
