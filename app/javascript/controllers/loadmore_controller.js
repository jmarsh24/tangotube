  import { Controller } from 'stimulus'
  import Rails from '@rails/ujs'

  export default class extends Controller {
    static targets = ['videos', 'loadmore']
    static values = { page: Number }

    connect() {
      console.log('loadmore controller on!')
    }

    loadMore () {
      const url = new URL(window.document.location)

      if (url.searchParams == '') {
          url.searchParams.append('page', this.pageValue++)
        } else {
          url.searchParams.set('page', this.pageValue++)
        }

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
