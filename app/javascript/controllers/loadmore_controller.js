import { Controller } from 'stimulus'
import Rails from '@rails/ujs'

export default class extends Controller {
  static targets = ['videos', 'loadmore']
  static values = { nextpage: Number }

  loadMore () {
    const url = new URL(window.document.location)

    if (url.searchParams == '') {
      url.searchParams.append('page', this.nextpageValue++)
    } else {
      url.searchParams.set('page', this.nextpageValue++)
    }

    Rails.ajax({
      type: 'GET',
      url: url,
      dataType: 'json',
      success: data => {
        document
          .getElementById('videos')
          .insertAdjacentHTML('beforeend', data.videos)
        document.getElementById('load-more-container').innerHTML = data.loadmore
      }
    })
  }
}
